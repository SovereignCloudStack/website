---
layout: post
title: "Preferring diskless flavors in SCS"
author:
  - "Kurt Garloff"
avatar:
  - "avatar-garloff.jpg"
image: "blog/diskless/diskless.jpg"
---

## Flavor standardization

SCS offers the promise to make it easy for Cloud users (typically DevOps teams
that develop and operate services / workloads on top of SCS IaaS and/or
Container infrastructure) to move between different SCS enviroments and vendors
or to use several of them in a federated way. One of the early accomplishments
in standardizing SCS has been to standardize IaaS flavor properties and flavor
naming.

On OpenStack (like on many other IaaS environments), when you create a virtual
machine (VM), you can not chose an arbitrary amount of (virtual) CPUs or memory
(RAM). Instead you have a discrete set of choices, so called flavors. They
combine an amount of vCPUs with a certain amount of RAM and often also a
virtual disk to boot from. On a typical VM creation, an operating system image
is being copied to the disk (of a size defined by the chosen flavor) on the
compute host, vCPUs and RAM are allocated (according to the numbers defined in
the chosen flavor) and the virtual then can start booting.

While this is not as flexible as some users might like, this is how most clouds
do it. On SCS environments, a number of standard flavors exist, e.g. flavors
with 4vCPUs, 8GiB of RAM and a 20GB root disk (`SCS-4V-8-20`) or one
with 4vCPUs, 16GiB of RAM and a 50GB root disk (`SCS-4V-16-50`).

## Diskless flavors

Creating a set of flavors that caters to the needs of most users results in
a non-trivial amount of flavors. Some workloads require more compute power
(thus more vCPUs), some require more RAM. So, many combinations of these
will be needed. The mandatory flavors in SCS cover 1 through 16 vCPUs and
2 through 32GiB of RAM, with ratios of 1:2, 1:4 and 1:8 between vCPUs and
RAM (in GiB). This results in 12 flavors. (There is one additional flavor
for tiny machines, `SCS-1L-1`, resulting in 13 flavors actually.)
Of course, providers can implement many more based on the needs of their
users -- these are then just not guaranteed to be available on all SCS
environments.

Adding a variety of root disk sizes now multiplies these flavors.
In versions [1](https://docs.scs.community/standards/scs-0100-v1-flavor-naming)
and [2](https://docs.scs.community/standards/scs-0100-v2-flavor-naming)
of the flavor standard, the SCS community has tried to
prevent flavor explosion by just mandating one disk size per flavor, scaling
it with the size of the RAM and chosing discete values of 5, 10, 20,
50 and 100 GB for them. (By extension, providers that want to provide
larger disks have been advised to choose 200, 500, 1000, ... GB for these.)

Next to the each flavor with a root disk size (e.g. `SCS-4V-16-50`), SCS
also mandates a flavor without a root disk (e.g. `SCS-4V-16`). This is useful,
as OpenStack also allows users to boot from a preexisting disk ("volume")
or to allocate block storage (a virtual disk) with
arbitrary size upon VM creation, although it is a bit more complicated (see
below). So we have one disk size per vCPU-RAM combination for simplicity
and the flexibility to have an arbitrary disk size with a bit more effort.
This is what we had for the SCS flavor standards v1 and v2.

With [v3](https://docs.scs.community/standards/scs-0100-v3-flavor-naming),
we also [added](https://docs.scs.community/standards/scs-0100-v2-flavor-naming)
two flavors with (at least) SSD type root disk storage.
Adding all combinations here would have again resulted in many new flavors.
Yet the cloud operators in the SCS community really wanted to avoid a
proliferation of many new flavors mandated by the standards. The SCS community
agreed on avoiding more mandatory flavors and instead stopped mandating
the flavors with disks (except for the two new ones with SSDs, more on this
later).

With the [SCS flavor standard v3](https://docs.scs.community/standards/scs-0100-v3-flavor-naming),
the formerly mandatory flavors with disk
have been downgraded to recommended. Operators still should provide them for
best portability of apps written against older SCS standards, but they are no
longer required to in order to be able to achieve the SCS-compatible certification
on the IaaS layer. We recommend developers to use the diskless flavors and
allocate root disks dynamically.

The next section explains how this can be done and uses examples from SCS'
own projects.

## Creating VMs with diskless flavors

### Horizon
In the second page of the create instance dialogues, you can chose to
create a volume of any size you want (though you better make it large
enough to accommodate the needs of the used image) and you can also
choose that the disk should be destroyed upon destruction of the VM
as it would if you had used a flavor with disk. This second page
can be seen on the horizon screensho. One the third page,
choose a diskless flavor.
<figure class="figure mx-auto d-block" style="width:100%">
    {% asset 'blog/diskless/Horizon-VM-Create.png' class="figure-img w-100" alt="Horizon Instance Create p2"%}
    <figcaption>Horizon's VM instance creation dialog page 2</figcaption>
</figure>


The VM instance will boot normally. You can see the volume in the
volume list; it has no name but you can see it being attached to your
freshly booted VM. If you have activated the "Delete Volume on Instance Delete"
setting, it will vanish as soon as you destroy the VM instance.

The fact that no name can be assigned to the volume is a limitation
of the OpenStack nova API. (But of course you could assign a name
manually after it has been created.)

### OpenStack API
Horizon of course uses an API call to create the VM instance with
a volume allocated on the fly. This is a `POST` REST call to the
compute (nova) endpoint of your cloud and the settings are described
in the [nova API documentation](https://docs.openstack.org/api-ref/compute/?expanded=create-server-detail#create-server).

To allocate a disk (volume), the (optional) `block_device_mapping_v2`
parameter is passed with settings like
```json
 "block_device_mapping_v2": [{
   "boot_index": 0,
   "uuid": "$IMAGE_UUID",
   "source_type": "image",
   "volume_size": $WANTED_SIZE,
   "destination_type": "volume",
   "delete_on_termination": true,
   "volume_type": "__DEFAULT__",
   "disk_bus": "scsi" }]
```

Obviously, you would replace `$IMAGE_UUID` and `$WANTED_SIZE` by the wanted settings.
(The size is specified in GiB.)
You may leave out `volume_type` and `disk_bus`. If you leave out `delete_on_termination`,
it will default to `false`, resulting in a volume that remains allocated after the VM
instance has been removed and thus behaving differently from the root volumes that come
with a flavor with root disk.
You can also add a `tag` property to place a tag on the created volume.

When using the openstack SDK, the API call would be invoked with
```python
vm = conn.compute.create_server(
	name="test-diskless",
	networks=[{"uuid": "2bc6b86c-77e2-4cfb-a2d1-7d7210b1e215"}],
	flavor_id="82889eb7-99d0-4025-a0a3-95b3b47f792a",
	key_name="SSHkey-gxscscapi",
	block_device_mapping_v2=[{'boot_index': 0,
		'uuid': '09337995-b91b-4763-8f6b-5e77f1d9d262',
		'source_type': 'image',
		'volume_size': 12,
		'destination_type': 'volume',
		'delete_on_termination': True}
	]
)
```
with the fields `name`, `uuid` in `networks`, `flavor_id`, `key_name`,
`uuid` in `block_device_mapping_v2`, `volume_size` according to your
needs. Note that the `block_device_mapping_v2`'s `uuid` is the `uuid`
of the wanted image.

### openstack-cli
#### Example: openstack-health-monitor
### terraform
### OCCM
#### Example: k8s-cluster-api-provider

## Why create the two (new) SSD flavors?
So when moving from flavor standard v2 to v3, we have downgraded all flavors
with disks from mandatory to recommended. Yet we have added two new flavors with
SSD (or better) storage as mandatory. This looks puzzling at first.

The reason why offering SSD storage is highly desirable is documented in the
[scs-0110-v1-ssd-flavors.md](https://docs.scs.community/standards/scs-0110-v1-ssd-flavors)
standard. But couldn't we use the mechanisms
described above to allocate arbitraty SSD storage when booting?

The unfortunate truth is: We can't.
This is for two reasons:
1. The [OpenStack server creation API](https://docs.openstack.org/api-ref/compute/?expanded=create-server-detail#create-server)
   does allow us to define a volume type when deploying an image to
   a volume only with recent API microversions (2.67 and newer).
   Not all tools support this yet.
   Or we could revert to a two step process and create the volume in a
   separate step where we choose an appropriate `volume_type` in volume
   creation and then tell nova to boot from it. 
2. The SCS project has not yet standardized on a cinder storage type that
   makes a networked SSD type storage available across all IaaS layer
   SCS-compatible clouds. So even the inconvenient two step process
   does not work across clouds in a portable way.
   Looking at the use cases of the SSD flavors, a local SSD (or better)
   type storage without the redundancy of a storage cluster is actually
   the desired property for these flavors. In the etcd case, the
   clustering is done by etcd; the same is true for big data use cases,
   where hadoop would take care of data replication and not expect the
   storage layer to do so. The local storage has the additional advantage
   of allowing for lower latency than you can get from networked storage.

So we need those two SSD flavors `SCS-2V-4-20s` and `SCS-4V-16-100s`
to serve our customers well. 
