---
layout: post
title: "Mechanism to provide node local storage in the OpenStack block storage service"
author:
  - "Jan Horstmann"
avatar:
  - "jhorstmann.jpg"
about:
  - "jhorstmann"
---

# Motivation

Currently there is node local storage in OpenStack in the form of nova ephemeral storage. As its name implies it is ephemeral in the sense that it is bound to the lifecycle of an instance. However, managing compute resources in a cloud native way usually requires storage to be decoupled from compute. Thus, there is a general benefit in making node local storage available in the block storage service.

There are multiple circumstances where node local storage may be desired or required by cloud operators or users.
* When built using open source software it would be a low-cost solution, thus facilitating adoption on small scales, where proprietary or even just dedicated storage solutions would be deemed to expensive.
* While being inherently not highly available above node level, local storage could be useful where IO performance is required and high available storage incurs too much latency through inter-node connections.
* Dedicated and especially highly available storage solutions can be very complex and increase failure domain, thus requiring special operational knowledge. In a risk-averse environment occasional small scale failures might be more tolerable than rare, but large-scale incidents.

# Architecture of an OpenStack cloud with node local storage via block storage service

From a cloud architectural perspective offering node local storage via block storage service requires a volume service on every compute node to manage volumes, so that they may be accessed by local instances. Since many storage volumes may be mapped to one (or possibly more) instances and could be remapped to other instances, a mechanism is needed to transparently migrate storage volumes to the compute node of the instance they are going to be attached to.
Live-migration of instances additionally requires storage volumes to be accessible on both the source and the destination node. However consistent writing from two nodes simultaneously is not a requirement.

# Proposal for a migration mechanism using the device-mapper clone target

One possible candidate for transparent storage volume migration is the Linux kernel's device-mapper dm-clone[^dm_clone] target. A device-mapper target which allows to create copies of block devices in the background, while being able to access and use the destination device transparently. The nature of the source device is irrelevant, i.e. it can be a local device or a device accessible via network by any means of transport, thus allowing to clone remote storage volumes.
Setup of a clone target requires a meta data device to keep track of where individual data blocks reside. Initially everything will point to the source device, once a block is copied or written on the destination device the meta data will be updated to point to the new location. This way all writes on the destination device will be local, albeit incurring a slight performance penalty due to the update of the meta data table. The data transferal is kept rather simple, there is no prioritisation of often read blocks and copying will be retried indefinitely until completion. The page cache or other caches will usually alleviate the performance penalty of the former, while the latter allows to complete the migration even after connectivity to the source device was temporarily interrupted.
The process of copying data is called `hydration` in the `dm-clone` targets terminology. The `clone` target may be created with hydration to be started immediately or stopped. Copying may be started and stopped at any time by sending a message to the device-mapper target.
Once the migration is complete the clone target may be replaced by a linear target with a short suspend/resume cycle leading to a small spike in IO latency. Afterwards the meta data device may be discarded.

The dm-clone target however lacks a means to specify device offsets. A feature needed to construct complex targets spanning multiple devices as the device-mapper's `linear` target offers and is most prominently used by the `lvm2` project. Therefore, in order to provide the most flexibility, it is proposed to use the `dm-clone` target stacked on top of device-mapper targets provided by `lvm2`. This implies, that after migration a linear target will be stacked on top of the linear `lvm2` target.

## Notes on multi-attachments

Since writes are always handled locally to the node they occur on, no actual multi-attachments can be supported using the device-mapper `clone` target. However, multi-attachments on two nodes for the same instance are a prerequisite for live migration of instances with attached volumes[^live_migration]. In this scenario writes only occur on either the source node or the destination node after successful live migration. With these preconditions it is possible to attach the volume in the described manner on the destination node. The hydration must however only be started once the device is detached on the source, since otherwise writes on the source might be masked on the destination node by blocks which have been transferred before. This implies that hydration may only start once there are no further attachments.
In case of a failed live migration the detachment of the volume on the destination needs to include a clean-up of the created device-mapper targets.

# Failure modes

By definition node local storage is not highly available above node level. Thus, any application making use of this driver needs to be able to either tolerate or mitigate outages. Proper processes need to be in place to restore lost nodes or recover their data if they cannot be restored and data has not been replicated on the application level.

Additional to the common risk of failure while data is at rest on a single node (i.e. not in the process of being migrated), the proposed mechanism introduces failure modes while data is in transit (i.e. during the process of being migrated).
Naturally for a given risk of failure of a single node, the risk is doubled during the time frame of data migration between two nodes. Additionally network partitions or failure may occur, thus increasing the risk further. The overall risk may be reduced by reducing the time frame of migration through increased network bandwidth.
In case of the source being unreachable either by node or network failure, data may not be read leading to read IO errors on the destination node, which will be further handled by the filesystem in use. According to the [dm-clone documentation](https://docs.kernel.org/admin-guide/device-mapper/dm-clone.html) it will try to transfer data indefinitely, so the situation can be fixed by re-exposing the source and remounting the filesystem on the user side.
Failure of or on the destination node will naturally lead to immediate unavailability of the data and potentially also of its consuming workload. Recovery includes detection of volumes with in-progress migrations. This could be done by tracking migration state externally or simply by checking for the existence of meta data volumes. Reconstruction of the clone target could then be done by connecting the corresponding source and re-creating the device-mapper clone target. Once hydration is re-enabled the migration process will continue.

# Security impact

A cinder-volume service is required on each compute node. The service requires access to the cinder database, thus requiring database credentials to be stored on the compute node.

# Implementation of volume driver actions

The following is a proposal for a cinder driver leveraging the `dm-clone` target to transfer local storage volumes.

## Volume state diagram

The diagram shows how the `status` and `migration_status` of the volumes involved change when certain API Calls are made. Two parts may not be immediately obvious:
* When `initialize_connection` is called for a `reserved` volume the IP address in the provided connector object needs to be resolved to a host running the volume-service with this driver as backend.
  For the special case that it is the volume-service holding the volume a connector object of type `local` is directly returned and the volume may be attached.
  For the general case of the volume being on a remote volume-service a new volume object is created and used to create a volume on the remote service, which from the `migration_status` can infer that a `dm-clone` target is required. Using the `_name_id` attribute the volume identities are immediately switched, so that the volume which is going to be attached resolves to the volume on the remote volume-service and vice versa (a concept already employed during volume migrations[^vol_migration]). The volume may then be attached. After hydration finishes, the source volume is deleted.
* For live-migration scenarios the same instance is allowed to attach a volume a second time on a different host. The same mechanism as described above is used to setup a volume and a `dm-clone` target on the destination host, but the hydration will not be enabled immediately.
  When a connection is terminated and it is local to the volume-service it means that the volume on the destination host of the live-migration is detached. In this case everything is rolled back to the initial state.
  If the termination is from the remote host it means the source volume is disconnected and the instance is now running on the destination. In this case the hydration is enabled and the connection is terminated on the source host.

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/local-block-storage-via-dm-clone-volume-states-diagram.svg" @path %}">
    {% asset 'blog/local-block-storage-via-dm-clone-volume-states-diagram.svg' class="figure-img w-100" %}
  </a>
</figure>

## Driver methods

This chapter outlines the necessary actions required in each driver method[^driver_ref].

* `create_volume`
  * Create a local `lvm2` logical volume.
  * If `status` is `maintenance` and `migration_status` is `starting`/`migrating`
    * Find the target volume with `migration_status` `target:UUID`
    * Attach the source volume by initiating a connection to the target on the source
    * Create a metadata device using `lvm2` volumes on a configurable and preferably fast storage device
    * Create a `clone` target target for the new volume referencing the metadata, source and destination device with hydration disabled. (Disabling the hydration should allow a limited form of multi-attachment which is required for live migration. See notes on multi-attachments)
    * If `migration_status` is `migrating`
      * Enable hydration
* `validate_connector`
  * Map connector `ip` to a suitable volume host or fail
* `initialize_connection`
  * If connector IP is from the same host
    * Add a device-mapper `linear` target stacked on top of the `lvm2` volume. At this point this is just for consistency.
    * return `local` connector
  * If connector IP is from a different host
    * If volume `status` is `reserved`
       * Create new volume object (`status`: `maintenance`, `migration_status`: `migrating`)
    * If volume `status` is `in-use`
       * Create new volume object (`status`: `maintenance`, `migration_status`: `starting`)
    * Set volume's `migration_status` to `target:UUID`, where `UUID` is the UUID of the new volume
    * RPC to `create_volume` on destination with new volume object
    * Switch each volumes identity by setting `_name_id` to the other volume's UUID
    * return `local` connector for volume
* `terminate_connection`
  * If volume `status` is `reserved` and `migration_status` is `target:UUID`
    * Revert volume identities of this and target volume by setting `_name_id` to the other volume's UUID
    * Remove `clone` target on the local volume
    * Remove the metadata device if it exists
    * Close initiator to the source volume target
    * RPC to `remove_export` on source
    * Call `delete_volume` on the local volume
    * Reset `migration_status` to `None` on the other volume
  * If volume `status` is `in-use` and `migration_status` is `target:UUID`
    * If `ip` in `connector` is of the local service, i.e. the volume on the destination of a live-migration is disconnected (live-migration aborted)
      * Revert volume identities of this and target volume by setting `_name_id` to the other volume's UUID
      * Remove `clone` target on the local volume
      * Remove the metadata device if it exists
      * Close initiator to the source volume target
      * RPC to `remove_export` on source
      * Call `delete_volume` on the local volume
      * Call `delete_volume` on the local volume
      * Reset `migration_status` to `None` on the other volume
    * If `ip` in `connector` is of a remote service, i.e. the volume on the source of a live-migration is disconnected (live-migration successful)
      * Find the source volume according to the UUID in `migration_status` `target:UUID`
      * Set `migration_status` of the source volume to `migrating`
      * enable hydration
  * If volume `status` is `detaching`
    * Remove the linear target on the volume
* `delete_volume`
  * Delete the `lvm2` volume itself

## Required periodic jobs on each volume service

A finished hydration does not trigger any actions, so a periodic check is required to clean up afterwards.

* For volumes of this host in `migration_status` `target:UUID`, check the state of the `clone` target for completed hydration
  * Set `migration_status` to `completing`
  * Load a `linear` target
  * Remove the metadata device
  * Close initiator to the source volume target
  * RPC to `remove_export` for the source volume
  * RPC to `delete_volume` for the source volume
  * Set `migration_status` to `success`

## Tasks required on startup of the volume service

This describes tasks which are required on startup of a volume-service.

* For volumes with `status` `in-use` and `migration_status` `None`
  * Ensure there is  a linear device-mapper target on top of the `lvm2` volume
* For volumes with `migration_status` `target:UUID`
  * Find the source volume according to the UUID in `migration_status` `target:UUID`
  * RPC to `create_export` on remote host for the source volume
  * Attach the source volume by initiating a connection to the target on the source
  * Create a `clone` target on top of the new volume referencing the metadata, source and destination device
  * If `migration_status` of the source volume is `migrating`
    * enable hydration
* For volumes with `status` `maintenance` and `migrations_status` `starting` or `migrating`
  * Ensure the volume is exported

# Demo setup

The following commands may be used to showcase the creation and transferal using the mechanisms described above.

* Create two virtual machines with an additional disk

On both nodes:

* Create an `lvm` physical volume on the additional device, e.g.
  ```
  pvcreate /dev/sdb
  ```
* Create a volume group on the physical volume, e.g.:
  ```
  vgcreate vg0 /dev/sdb
  ```

On the first node:

* Create a demo volume on the volume group, e.g.:
  ```
  lvcreate --size 5G -n volume-1234 vg0
  ```
* Add a linear device-mapper target on top of the `lv`, e.g.:
  ```
  dmsetup create volume-1234-handle --table "0 10477568 linear /dev/vg0/volume-1234 0"
  ```
* Optionally: Add some random data, e.g.:
  ```
  mkfs.xfs /dev/mapper/volume-1234-handle
  mount /dev/mapper/volume-1234-handle /mnt
  dd if=/dev/random of=/mnt/foo bs=1M count=1024
  sync
  sha256sum /mnt/foo
  umount /mnt
  ```
* Export the target via iSCSI, e.g.:
  ```
  tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2024-04.tech.osism:volume-1234
  tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1 -b /dev/mapper/volume-1234-handle
  tgtadm --lld iscsi --mode logicalunit --op update --tid 1 --lun 1 --params readonly=1
  tgtadm --lld iscsi --mode target --op bind --tid 1 -I ALL
  tgtadm --lld iscsi --mode target --op show
  ```

On the second node:

* Create a volume to hold the data, e.g.:
  ```
  lvcreate --size 5G -n volume-1234 vg0
  ```
* Add a linear device-mapper target on top of the `lv`, e.g.:
  ```
  dmsetup create volume-1234-handle --table "0 10477568 linear /dev/vg0/volume-1234 0"
  ```
* Create a logical volume to hold the `dm-clone` metadata, e.g.:
  ```
  lvcreate --size 1G -n volume-1234-meta vg0
  ```
* Initiate the iSCSI connection, e.g.:
  ```
  iscsiadm -m discovery -t sendtargets -p 192.168.122.60
  iscsiadm -m node --login --targetname iqn.2024-04.tech.osism:volume-1234
  ```
* Load a `dm-clone` target instead of the linear target, e.g.:
  ```
  dmsetup suspend volume-1234-handle
  dmsetup load volume-1234-handle --table "0 10477568 clone /dev/vg0/volume-1234-meta /dev/vg0/volume-1234 /dev/sdc 8 1 no_hydration"
  dmsetup resume volume-1234-handle
  ```
* Start using the `dm-clone` target immediately, e.g.:
  ```
  mount /dev/mapper/volume-1234-handle /mnt
  dd if=/dev/random of=/mnt/bar bs=1M count=1024
  sha256sum /mnt/foo
  sha256sum /mnt/bar
  ```

* Enable hydration of the `dm-clone` target, e.g.:
  ```
  dmsetup message volume-1234-handle 0 enable_hydration
  ```

* Check the status of the `dm-clone` target:
  ```
  dmsetup status
  ```

* Once all extends are local, load a linear target again, e.g.:
  ```
  dmsetup suspend volume-1234-handle
  dmsetup load volume-1234-handle --table "0 10477568 linear /dev/vg0/volume-1234 0"
  dmsetup resume volume-1234-handle
  ```

* Remove the metadata `lv`, e.g.:
  ```
  lvremove -y vg0/volume-1234-meta
  ```

* Terminate the iSCSI connection, e.g.:
  ```
  iscsiadm -m node --logout --targetname iqn.2024-04.tech.osism:volume-1234
  iscsiadm -m node --op=delete
  ```

On the first node:

* Stop the iSCSI export, e.g.:
  ```
  tgtadm --lld iscsi --mode target --op unbind --tid 1 -I ALL
  tgtadm --lld iscsi --mode logicalunit --op delete --tid 1 --lun 1

* Remove the linear device mapper target, e.g.:
  ```
  dmsetup remove volume-1234-handle
  ```

* Remove the source `lv`, e.g.:
  ```
  lvremove -y vg0/volume-1234
  ```

## Benchmarks of the demo setup

The following benchmarks show the influence of the meta data device on the random 4k write speed. The test setup is a virtual machine with virtio-scsi disks backend by raw files. The clone is setup between local `lvm2` devices.
The local benchmarks show a drop to about one third of the base line 4k random write IOPS when using an `lvm2` volume on the source disk as metadata device. For comparison, putting the metadata on a ZRAM device yields no measurable drop in 4k random write performance.
The benchmarks on a remote node where the source is exported via ISCSI and the meta data is written to a ZRAM device shows no drop in random 4k write IOPS as it would be expected since only local storage is involved. The random 4k read IOPS show a sharp drop due to being remote over the ISCSI protocol.

Note that due to its ephemeral nature a ZRAM device is not recommended for production use cases. It is used here to show case the influence of the meta data device speed. However, the results show that production setups would probably benefit from using dedicated NVMes for meta data storage.

### Baseline

Benchmarks of the source volume locally

#### Random 4k writes

```
root@com01:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randwrite -runtime=60 -filename=/dev/mapper/vg0-volume--1234
test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=5465KiB/s][w=1366 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=3240: Sat Jun  1 15:58:06 2024
  write: IOPS=1375, BW=5502KiB/s (5634kB/s)(322MiB/60001msec); 0 zone resets
    slat (usec): min=4, max=259, avg=11.65, stdev= 7.09
    clat (usec): min=312, max=8516, avg=714.14, stdev=164.99
     lat (usec): min=317, max=8523, avg=725.93, stdev=167.56
    clat percentiles (usec):
     |  1.00th=[  359],  5.00th=[  424], 10.00th=[  644], 20.00th=[  668],
     | 30.00th=[  685], 40.00th=[  701], 50.00th=[  717], 60.00th=[  725],
     | 70.00th=[  742], 80.00th=[  766], 90.00th=[  799], 95.00th=[  832],
     | 99.00th=[ 1106], 99.50th=[ 1450], 99.90th=[ 1795], 99.95th=[ 1958],
     | 99.99th=[ 7570]
   bw (  KiB/s): min= 5240, max= 5712, per=100.00%, avg=5505.12, stdev=100.03, samples=119
   iops        : min= 1310, max= 1428, avg=1376.28, stdev=25.01, samples=119
  lat (usec)   : 500=5.98%, 750=67.98%, 1000=24.66%
  lat (msec)   : 2=1.33%, 4=0.02%, 10=0.03%
  cpu          : usr=0.34%, sys=1.57%, ctx=165058, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,82529,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=5502KiB/s (5634kB/s), 5502KiB/s-5502KiB/s (5634kB/s-5634kB/s), io=322MiB (338MB), run=60001-60001msec
```

#### Random 4k reads

```
root@com01:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randread -runtime=60 -filename=/dev/mapper/vg0-volume--1234
test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=111MiB/s][r=28.3k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=13731: Sat Jun  1 16:29:11 2024
  read: IOPS=27.3k, BW=107MiB/s (112MB/s)(5120MiB/47966msec)
    slat (usec): min=2, max=110, avg= 3.68, stdev= 1.45
    clat (nsec): min=301, max=1126.9k, avg=32586.49, stdev=12584.72
     lat (usec): min=21, max=1130, avg=36.32, stdev=13.66
    clat percentiles (usec):
     |  1.00th=[   23],  5.00th=[   24], 10.00th=[   26], 20.00th=[   28],
     | 30.00th=[   29], 40.00th=[   30], 50.00th=[   32], 60.00th=[   33],
     | 70.00th=[   35], 80.00th=[   36], 90.00th=[   39], 95.00th=[   43],
     | 99.00th=[   63], 99.50th=[   74], 99.90th=[  277], 99.95th=[  306],
     | 99.99th=[  355]
   bw (  KiB/s): min=95432, max=131840, per=100.00%, avg=109325.39, stdev=8206.01, samples=95
   iops        : min=23858, max=32960, avg=27331.35, stdev=2051.50, samples=95
  lat (nsec)   : 500=0.01%, 750=0.01%
  lat (usec)   : 4=0.01%, 10=0.01%, 20=0.01%, 50=97.63%, 100=2.15%
  lat (usec)   : 250=0.08%, 500=0.14%, 750=0.01%
  lat (msec)   : 2=0.01%
  cpu          : usr=3.58%, sys=16.91%, ctx=1310726, majf=0, minf=12
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1310720,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=107MiB/s (112MB/s), 107MiB/s-107MiB/s (112MB/s-112MB/s), io=5120MiB (5369MB), run=47966-47966msec
```

### Benchmark of a local clone with metadata on `lvm2` volume

#### Random 4k writes

```
root@com01:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randwrite -runtime=60 -filename=/dev/mapper/volume-1234-clone-handle
test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=2094KiB/s][w=523 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=3118: Sat Jun  1 15:54:49 2024
  write: IOPS=519, BW=2080KiB/s (2130kB/s)(122MiB/60002msec); 0 zone resets
    slat (usec): min=2, max=277, avg= 5.80, stdev= 6.91
    clat (usec): min=1576, max=14149, avg=1915.57, stdev=279.42
     lat (usec): min=1579, max=14269, avg=1921.53, stdev=280.86
    clat percentiles (usec):
     |  1.00th=[ 1696],  5.00th=[ 1745], 10.00th=[ 1762], 20.00th=[ 1795],
     | 30.00th=[ 1827], 40.00th=[ 1844], 50.00th=[ 1876], 60.00th=[ 1909],
     | 70.00th=[ 1926], 80.00th=[ 1975], 90.00th=[ 2040], 95.00th=[ 2147],
     | 99.00th=[ 3064], 99.50th=[ 3326], 99.90th=[ 3916], 99.95th=[ 8586],
     | 99.99th=[ 9634]
   bw (  KiB/s): min= 2008, max= 2176, per=100.00%, avg=2080.94, stdev=33.12, samples=119
   iops        : min=  502, max=  544, avg=520.24, stdev= 8.28, samples=119
  lat (msec)   : 2=85.54%, 4=14.36%, 10=0.09%, 20=0.01%
  cpu          : usr=0.08%, sys=0.51%, ctx=31572, majf=0, minf=9
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,31199,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=2080KiB/s (2130kB/s), 2080KiB/s-2080KiB/s (2130kB/s-2130kB/s), io=122MiB (128MB), run=60002-60002msec
```

#### Random 4k reads

```
root@com01:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randread -runtime=60 -filename=/dev/mapper/volume-1234-handle
test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=104MiB/s][r=26.6k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=15863: Mon Jun  3 05:57:42 2024
  read: IOPS=27.2k, BW=106MiB/s (111MB/s)(5116MiB/48142msec)
    slat (usec): min=2, max=123, avg= 3.73, stdev= 1.40
    clat (nsec): min=271, max=882821, avg=32723.17, stdev=11044.33
     lat (usec): min=20, max=886, avg=36.51, stdev=12.17
    clat percentiles (usec):
     |  1.00th=[   23],  5.00th=[   28], 10.00th=[   29], 20.00th=[   29],
     | 30.00th=[   30], 40.00th=[   33], 50.00th=[   34], 60.00th=[   34],
     | 70.00th=[   35], 80.00th=[   35], 90.00th=[   36], 95.00th=[   37],
     | 99.00th=[   47], 99.50th=[   69], 99.90th=[  273], 99.95th=[  285],
     | 99.99th=[  318]
   bw (  KiB/s): min=104464, max=117576, per=100.00%, avg=108874.50, stdev=2902.41, samples=96
   iops        : min=26116, max=29394, avg=27218.67, stdev=725.57, samples=96
  lat (nsec)   : 500=0.01%
  lat (usec)   : 10=0.01%, 20=0.01%, 50=99.18%, 100=0.62%, 250=0.05%
  lat (usec)   : 500=0.14%, 1000=0.01%
  cpu          : usr=3.01%, sys=18.29%, ctx=1309719, majf=0, minf=13
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1309696,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=106MiB/s (111MB/s), 106MiB/s-106MiB/s (111MB/s-111MB/s), io=5116MiB (5365MB), run=48142-48142msec
```

### Benchmark of a local clone with metadata on ZRAM

#### Random 4k writes

```
root@com01:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randwrite -runtime=60 -filename=/dev/mapper/volume-1234-handle
test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=4960KiB/s][w=1240 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=13608: Sat Jun  1 16:14:04 2024
  write: IOPS=1478, BW=5913KiB/s (6055kB/s)(346MiB/60001msec); 0 zone resets
    slat (nsec): min=1923, max=208986, avg=3724.87, stdev=4766.17
    clat (usec): min=344, max=10388, avg=671.61, stdev=237.71
     lat (usec): min=347, max=10470, avg=675.43, stdev=239.08
    clat percentiles (usec):
     |  1.00th=[  375],  5.00th=[  392], 10.00th=[  396], 20.00th=[  412],
     | 30.00th=[  441], 40.00th=[  717], 50.00th=[  750], 60.00th=[  775],
     | 70.00th=[  799], 80.00th=[  824], 90.00th=[  865], 95.00th=[  906],
     | 99.00th=[ 1156], 99.50th=[ 1500], 99.90th=[ 1926], 99.95th=[ 2024],
     | 99.99th=[ 7832]
   bw (  KiB/s): min= 4624, max= 9728, per=100.00%, avg=5924.30, stdev=1891.50, samples=119
   iops        : min= 1156, max= 2432, avg=1481.08, stdev=472.87, samples=119
  lat (usec)   : 500=34.29%, 750=16.58%, 1000=47.48%
  lat (msec)   : 2=1.60%, 4=0.04%, 10=0.02%, 20=0.01%
  cpu          : usr=0.35%, sys=0.72%, ctx=90151, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,88703,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=5913KiB/s (6055kB/s), 5913KiB/s-5913KiB/s (6055kB/s-6055kB/s), io=346MiB (363MB), run=60001-60001msec
```

#### Random 4k reads

```
root@com01:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randread -runtime=60 -filename=/dev/mapper/volume-1234-handle
test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=119MiB/s][r=30.5k IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=13734: Sat Jun  1 16:30:16 2024
  read: IOPS=31.1k, BW=122MiB/s (128MB/s)(5116MiB/42051msec)
    slat (usec): min=2, max=156, avg= 3.76, stdev= 1.55
    clat (nsec): min=271, max=2064.1k, avg=28045.10, stdev=10645.06
     lat (usec): min=18, max=2068, avg=31.85, stdev=11.88
    clat percentiles (usec):
     |  1.00th=[   22],  5.00th=[   23], 10.00th=[   25], 20.00th=[   27],
     | 30.00th=[   28], 40.00th=[   28], 50.00th=[   28], 60.00th=[   29],
     | 70.00th=[   29], 80.00th=[   29], 90.00th=[   30], 95.00th=[   32],
     | 99.00th=[   40], 99.50th=[   43], 99.90th=[  273], 99.95th=[  285],
     | 99.99th=[  326]
   bw (  KiB/s): min=119528, max=132216, per=100.00%, avg=124645.90, stdev=2967.37, samples=84
   iops        : min=29882, max=33054, avg=31161.51, stdev=741.82, samples=84
  lat (nsec)   : 500=0.01%
  lat (usec)   : 10=0.01%, 20=0.01%, 50=99.66%, 100=0.16%, 250=0.05%
  lat (usec)   : 500=0.13%, 750=0.01%, 1000=0.01%
  lat (msec)   : 4=0.01%
  cpu          : usr=4.25%, sys=19.24%, ctx=1309700, majf=0, minf=13
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1309696,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=122MiB/s (128MB/s), 122MiB/s-122MiB/s (128MB/s-128MB/s), io=5116MiB (5365MB), run=42051-42051msec
```

### Benchmarks of a clone on a remote node with source disk exported via ISCSI and meta data on ZRAM

#### Random 4k writes

```
root@com02:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randwrite -runtime=60 -filename=/dev/mapper/volume-1234-handle
test: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=4828KiB/s][w=1207 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=13249: Mon Jun  3 06:22:28 2024
  write: IOPS=1252, BW=5008KiB/s (5129kB/s)(293MiB/60001msec); 0 zone resets
    slat (usec): min=2, max=156, avg= 4.12, stdev= 4.86
    clat (usec): min=592, max=11421, avg=793.32, stdev=166.41
     lat (usec): min=594, max=11551, avg=797.55, stdev=168.01
    clat percentiles (usec):
     |  1.00th=[  668],  5.00th=[  693], 10.00th=[  709], 20.00th=[  725],
     | 30.00th=[  742], 40.00th=[  758], 50.00th=[  775], 60.00th=[  791],
     | 70.00th=[  807], 80.00th=[  832], 90.00th=[  873], 95.00th=[  906],
     | 99.00th=[ 1369], 99.50th=[ 1598], 99.90th=[ 1975], 99.95th=[ 2278],
     | 99.99th=[ 7832]
   bw (  KiB/s): min= 4784, max= 5360, per=100.00%, avg=5012.24, stdev=114.56, samples=119
   iops        : min= 1196, max= 1340, avg=1253.06, stdev=28.64, samples=119
  lat (usec)   : 750=34.40%, 1000=63.55%
  lat (msec)   : 2=1.96%, 4=0.06%, 10=0.03%, 20=0.01%
  cpu          : usr=0.30%, sys=0.71%, ctx=75869, majf=0, minf=10
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,75126,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=5008KiB/s (5129kB/s), 5008KiB/s-5008KiB/s (5129kB/s-5129kB/s), io=293MiB (308MB), run=60001-60001msec
```

#### Random 4k reads

```
root@com02:~# fio -ioengine=libaio -sync=1 -direct=1 -invalidate=1 -name=test -bs=4k -iodepth=1 -rw=randread -runtime=60 -filename=/dev/mapper/volume-1234-handle
test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=1
fio-3.28
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=28.9MiB/s][r=7398 IOPS][eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=13270: Mon Jun  3 06:24:09 2024
  read: IOPS=8113, BW=31.7MiB/s (33.2MB/s)(1902MiB/60001msec)
    slat (usec): min=2, max=118, avg= 4.32, stdev= 1.97
    clat (usec): min=15, max=1580, avg=118.39, stdev=57.89
     lat (usec): min=20, max=1626, avg=122.77, stdev=58.94
    clat percentiles (usec):
     |  1.00th=[   22],  5.00th=[   23], 10.00th=[   25], 20.00th=[  109],
     | 30.00th=[  120], 40.00th=[  126], 50.00th=[  130], 60.00th=[  135],
     | 70.00th=[  139], 80.00th=[  143], 90.00th=[  153], 95.00th=[  161],
     | 99.00th=[  202], 99.50th=[  253], 99.90th=[  889], 99.95th=[ 1123],
     | 99.99th=[ 1303]
   bw (  KiB/s): min=22160, max=142592, per=100.00%, avg=32493.65, stdev=20557.03, samples=119
   iops        : min= 5540, max=35648, avg=8123.41, stdev=5139.26, samples=119
  lat (usec)   : 20=0.01%, 50=15.38%, 100=3.30%, 250=80.80%, 500=0.32%
  lat (usec)   : 750=0.06%, 1000=0.05%
  lat (msec)   : 2=0.08%
  cpu          : usr=1.16%, sys=6.48%, ctx=486795, majf=0, minf=13
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=486792,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=31.7MiB/s (33.2MB/s), 31.7MiB/s-31.7MiB/s (33.2MB/s-33.2MB/s), io=1902MiB (1994MB), run=60001-60001msec
```


# References

[^dm_clone]: https://docs.kernel.org/admin-guide/device-mapper/dm-clone.html
[^live_migration]: https://specs.openstack.org/openstack/nova-specs/specs/pike/approved/cinder-new-attach-apis.html
[^driver_ref]: https://docs.openstack.org/cinder/latest/contributor/drivers.html
[^vol_migration]: https://docs.openstack.org/cinder/latest/contributor/migration.html
