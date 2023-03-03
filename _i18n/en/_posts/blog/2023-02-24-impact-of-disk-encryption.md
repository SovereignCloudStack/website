---
layout: post
title: "Performance impact of disk encryption using LUKS"
author:
  - "Paul-Philipp Kuschy"
avatar:
  - "ppkuschy.jpg"
about:
  - "ppkuschy"
image: "blog/luks-performance-impact.png"
---

## Preface

During some weekly meetings of SCS Team Container and also 
SCS Team IaaS the question emerged whether or not generally 
enabling full disk encryption on servers - especially related 
to software defined storage like Ceph - should be the default.

While in general enabling disk encryption can be considered a good 
thing that many people would agree with, there is a difference between 
enabling <abbr title="Full Disk Encryption">FDE</abbr> on your personal 
computing devices versus servers in a 
datacenter environment, especially when a lot of drives need to be 
encrypted.

The concerns voiced were that the performance impact would be 
tremendous. But since no actual data was available at hand to showcase 
how big that impact could become, I voluntered to dig into 
the matter at hand and do benchmarks.

Also with the availability of self encrypting drives, the practical 
application of that technology had to be evaluated.

## "Almost" TL;DR

### Impact on spinning disks

The benchmarks show that the additional overhead for encryption on 
spinning disks is not that big regarding CPU load (at least compared to NVME), 
mainly because the drives and controllers are the limiting factor there.

So SAS HDDs (even across 24 of them) aren't that big of a deal CPU-wise. 
It's still measurable, but even for <abbr title="Hyper converged infrastructure">HCI</abbr> 
nodes the impact is not so big that enabling encryption would possibly wreak havoc.

However bandwidth and IOPS losses are quite big and can 
lead - depending on the I/O pattern - to about **79 %** performance penalty. 
Worst performance losses were seen with sequential write (**up to 79 %**) 
followed by sequential read (**up to 53 %**). 
Random I/O losses were worst with random writes (**up to 43 %**) 
followed by random read (**up to 26 %**). In some single benchmarks 
performance was better than without encryption, up to **5 times faster** 
across a RAID-0 at 4 KiB sequential writes. 
This possibly can be attributed to optimized I/O queueing.

<p class="lead">
<strong>Recommendation:</strong> You can usually safely turn on disk encryption with HDDs, 
as it likely won't cause many problems regarding CPU load even within 
<abbr title="Hyper converged infrastructure">HCI</abbr>. 
However the performance penalty in throughput and IOPS can be quite tremendous 
compared to non-encrypted operation.
</p>

### Impact on all flash

On NVME all flash systems the load impact can be **gigantic**.
A RAID 0 across just three LUKS encrypted NVME SSDs was enough 
to fully saturate the CPU on test system B.

It shows in the fio data when adding up usr_cpu and sys_cpu values.  
During the benchmark runs I monitored the system additionally 
with `iostat` and `htop` and the following `htop` screenshot shows 
how big that impact can be.

<figure class="figure mx-auto d-block" style="width:100%; max-width: 986px;">
    {% asset 'blog/luks-performance-impact.png' class="figure-img w-100 mx-auto" %}
</figure>
<p class="fw-semibold text-center">That's an AMD EPYC 7402P with 100% CPU load across all threads/cores!</p>

This significantly increases power consumption and for 
<abbr title="Hyper converged infrastructure">HCI</abbr> nodes 
would be bad for other workloads running on it.

Heat dissipation could then also be challenging when whole racks suddenly 
dissipate way more heat than before. At least cost for cooling on top of 
the increased power consumption of the nodes would be really bad.

Bandwidth and IOPS losses are also quite big and can 
lead - depending on the I/O pattern - up to a **83 %** performance penalty. 
An I/O depth of 32 reduces the losses significantly. Worst performance losses 
with encryption were measured with the RAID-0 in most cases.  
Performance losses sorted by I/O type worst to best were random writes (**up to 83 %**), 
sequential write (**up to 83 %**), sequential read (**up to 81 %**) 
and finally random read (**up to 80 %**).  
All these worst values were with I/O size 1 and 4 MiB 
across the RAID-0 without I/O depth 32. One can clearly see however that 
all these worst values are within 5 %, so its rather the I/O size combined 
with the use of LUKS and MD RAID and not the drives.

**Caution:** It's difficult to compare the performance of MD RAID with Ceph OSDs!  
The performance impact when using Ceph could be totally different and will probably 
be more oriented towards the losses of individual drives. 
However the CPU load issue still remains.

**Regarding the CPU load:** There are crypto accelerator cards available which 
claim around 200 Gbps AES throughput and can integrate with dmcrypt 
through kernel modules.

These cards weren't available for testing, but judging from prices 
on the used market (I didn't find official price listings) 
for such cards and their power consumption specs they could provide 
a solution to offload the crypto operations from the CPU at a reasonable 
price point.

<p class="lead">
<strong>Recommendation:</strong> Further measurements regarding power consumption and crypto 
accelerators could be done. Also testing with an actual Ceph cluster on all flash 
is necessary to get a comparison of the losses compared to linux MD RAID. <br />
Every provider needs to evaluate that separately depending on their own configurations 
and hardware choices. <br />
<strong>As of now the performance impact without accelerators is too big to recommend 
generally enabling LUKS on NVME.</strong>
</p>

### Regarding the use of self encrypting drives:

It was possible to activate the encryption with a passphrase utilizing  
`sedutil` under linux. Performance impact was within measurement error,
so basically non-existent. That's why in the section below I didn't bother 
creating charts - the results are too similar to plain operation (as expected).

Unfortunately the tooling in its current state is cumbersome to use, 
also there would be a need to write scripts for integrating it into 
<abbr title="Network Bound Disk Encryption">NBDE</abbr> setups.  
(But it would be possible without too much hacking!)

However even though it **technically** works and performance impact is near zero, 
I encountered a severe showstopper for using that technology in servers, 
especially in cloud environments:

After powering down the system or manually locking the drive and rebooting, 
the system firmware stopped during POST to ask for the passphrase for each drive.

On the Supermicro server test system I found no way to disable that in BIOS/UEFI, 
which makes that technology not reboot-safe and thus unusable in server environments. 
**Even worse** was that even when trying to type in the passphrase, 
it wasn't accepted. So somehow the way `sedutil` stores the passphrase differs 
from what the firmware does?

<p class="lead">
<strong>Recommendation:</strong> The tooling needs to be polished and documentation 
significantly improved. Documentation on the tools is very confusing for the 
general system administrator and can easily lead to operator errors. <br />
Also due to the current BIOS/UEFI issues the technology cannot be recommended as of yet.
</p>

<p class="lead">
If vendors would provide a way to disable asking for the passphrase of certain drives 
it would be possible to use SEDs in a DC environment without the need of 
manual operator intervention when rebooting.
</p>

This concludes the TL;DR section.

So without further ado, let's dig into the details.

## The test setups

Two different test systems were used. Since no dedicated systems could be 
built/procured for the tests I used two readily available machines.  
The specs of these are:

### Test system A: SAS HDD only

<dl class="row">
<dt class="col-sm-1">CPU</dt><dd class="col-sm-11">2 x Intel(R) Xeon(R) Gold 6151 CPU @ 3.00GHz</dd>
<dt class="col-sm-1">RAM</dt><dd class="col-sm-11">512 GB</dd>
<dt class="col-sm-1">Drives</dt><dd class="col-sm-11">24 x HGST HUC101818CS4200 10k RPM 1.8 TB</dd>
</dl>

### Test system B: NVME all flash only

<dl class="row">
<dt class="col-sm-1">CPU</dt><dd class="col-sm-11">1 x AMD EPYC 7402P</dd>
<dt class="col-sm-1">RAM</dt><dd class="col-sm-11">512 GB (16 x 32 GB Samsung RDIMM DDR4-3200 CL22-22-22 reg ECC)</dd>
<dt class="col-sm-1">Drives</dt><dd class="col-sm-11">3 x Samsung MZQLB3T8HALS-00007 SSD PM983 3.84TB U.2</dd>
</dl>

### Benchmark specifications

On both systems I performed a series of benchmarks with `fio` using some custom 
scripts.  
I chose to test the following block sizes, since they can offer some insight 
into which I/O might cause what kind of load:

- 4 KiB
- 64 KiB
- 1 MiB
- 4 MiB (default object/"stripe" size for Ceph RBDs)
- 16 MiB
- 64 MiB

The following fio tests were performed:

- sequential read
- sequential write
- random read
- random write

All with option `--direct` and also repeated with `--iodepth=32` option 
and using libaio.

Those benchmarks were performed for:  

- The raw storage devices direct without encryption (e.g. one SAS disk, all NVME SSD)
- The raw storage devices with encryption
- A linux MD RAID 0 across all the devices without encryption
- A linux MD RAID 0 across all the devices with encryption on the base devices
- For the SED capable drives (only test system B) with SED turned on, 
  although no difference was expected there due to the fact that SED capable 
  drives usually always encrypt all their data with an internal key.  
  So enabling SED only encrypts that master key, requiring decryption after 
  locking the drive either through software or because of a power loss.  
  (Simplified, details can be found in the specifications like OPAL 2.0)

Benchmarking Ceph itself was skipped, because no suitable test setup was 
available that offered both NVME and SAS OSDs. But since enabling Ceph 
encryption is using LUKS encrypted OSDs, 
the results should be useful nonetheless.

## fio benchmark script
In case you want to run your own benchmarks, here is the script that was used to generate the data:

```bash
#!/bin/bash
LOGPATH="$1"
BENCH_DEVICE="$2"
mkdir -p $LOGPATH
IOENGINE="libaio"
DATE=`date +%s`
for RW in "write" "randwrite" "read" "randread"
do
  for BS in "4K" "64K" "1M" "4M" "16M" "64M"
  do
    (
    echo "==== $RW - $BS - DIRECT ===="
    echo 3 > /proc/sys/vm/drop_caches
    fio --rw=$RW --ioengine=${IOENGINE} --size=400G --bs=$BS --direct=1 --runtime=60 --time_based --name=bench --filename=$BENCH_DEVICE --output=$LOGPATH/$RW.${BS}-direct-`basename $BENCH_DEVICE`.$DATE.log.json --output-format=json
    sync
    echo 3 > /proc/sys/vm/drop_caches
    echo "==== $RW - $BS - DIRECT IODEPTH 32  ===="
    fio --rw=$RW --ioengine=${IOENGINE} --size=400G --bs=$BS --iodepth=32 --direct=1 --runtime=60 --time_based --name=bench --filename=$BENCH_DEVICE --output=$LOGPATH/$RW.${BS}-direct-iod32-`basename $BENCH_DEVICE`.$DATE.log.json --output-format=json
    sync
    ) | tee $LOGPATH/$RW.$BS-`basename $BENCH_DEVICE`.$DATE.log
    echo
  done
done
```

The script expects two parameters:
- First the path where to store the log files (the path will be created if it does not exist)
- Second argument is the device on which to run the benchmarks against

The script will produce a sequence of log files in JSON format, which can then be analyzed with tooling of your choice.

## Baseline LUKS algorithm performance

On both systems I first ran `cryptsetup benchmark` which performs 
some general benchmarking of algorithm throughput.
This was done to obtain the best possible LUKS configuration regarding 
throughput.

These were the results on test system A:

    PBKDF2-sha1      1370687 iterations per second for 256-bit key
    PBKDF2-sha256    1756408 iterations per second for 256-bit key
    PBKDF2-sha512    1281877 iterations per second for 256-bit key
    PBKDF2-ripemd160  717220 iterations per second for 256-bit key
    PBKDF2-whirlpool  543867 iterations per second for 256-bit key
    argon2i       5 iterations, 1048576 memory, 4 parallel threads (CPUs) for 256-bit key (requested 2000 ms time)
    argon2id      5 iterations, 1048576 memory, 4 parallel threads (CPUs) for 256-bit key (requested 2000 ms time)
    #     Algorithm |       Key |      Encryption |      Decryption
            aes-cbc        128b       904.3 MiB/s      2485.1 MiB/s
        serpent-cbc        128b        78.8 MiB/s       577.4 MiB/s
        twofish-cbc        128b       175.9 MiB/s       319.7 MiB/s
            aes-cbc        256b       695.8 MiB/s      2059.4 MiB/s
        serpent-cbc        256b        78.8 MiB/s       577.4 MiB/s
        twofish-cbc        256b       175.9 MiB/s       319.6 MiB/s
            aes-xts        256b      2351.5 MiB/s      2348.7 MiB/s
        serpent-xts        256b       560.1 MiB/s       571.4 MiB/s
        twofish-xts        256b       316.7 MiB/s       316.1 MiB/s
            aes-xts        512b      1983.0 MiB/s      1979.6 MiB/s
        serpent-xts        512b       560.5 MiB/s       571.3 MiB/s
        twofish-xts        512b       316.5 MiB/s       315.7 MiB/s


As you can see aes-xts 256 Bit performed the best, so when creating LUKS formatted devices 
I chose `-c aes-xts-plain64 -s 256` as parameters, which are also the defaults 
in many modern distributions. But just to be on the safe side I specified them explicitly.

Now let's have a look at the fio results for single disks and RAID-0, 
both encrypted and non-encrypted.

## Comparing read bandwidth

<style type="text/css">
#carousel-bw-read .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-bw-read .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-bw-read" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-bw-read" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/bw-read-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-read-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-bw-read" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-bw-read" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses read bandwidth

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>10,82 %</td><td>32,48 %</td><td>47,36 %</td><td>52,95 %</td><td>36,26 %</td><td>3,86 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>23,86 %</td><td>-0,06 %</td><td>-0,02 %</td><td>0,01 %</td><td>-0,05 %</td><td>-0,08 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>45,53 %</td><td>70,13 %</td><td>77,05 %</td><td>80,61 %</td><td>67,65 %</td><td>55,88 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>44,42 %</td><td>71,76 %</td><td>67,46 %</td><td>70,75 %</td><td>63,21 %</td><td>53,24 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>6,81 %</td><td>13,71 %</td><td>4,92 %</td><td>2,66 %</td><td>9,81 %</td><td>23,52 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>14,75 %</td><td>-0,65 %</td><td>-0,03 %</td><td>-0,03 %</td><td>0,21 %</td><td>0,13 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>40,99 %</td><td>60,02 %</td><td>51,61 %</td><td>49,68 %</td><td>48,62 %</td><td>48,62 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>40,64 %</td><td>21,57 %</td><td>1,89 %</td><td>1,89 %</td><td>1,98 %</td><td>2,43 %</td></tr>
</tbody>
</table>

## Comparing write bandwidth

<style type="text/css">
#carousel-bw-write .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-bw-write .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-bw-write" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-bw-write" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/bw-write-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-write-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-bw-write" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-bw-write" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses write bandwidth

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>-499,50 %</td><td>11,31 %</td><td>31,52 %</td><td>34,98 %</td><td>28,53 %</td><td>49,55 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>-59,93 %</td><td>-1,32 %</td><td>0,05 %</td><td>10,11 %</td><td>12,43 %</td><td>10,18 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>51,45 %</td><td>71,81 %</td><td>82,63 %</td><td>82,36 %</td><td>69,05 %</td><td>44,83 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>56,11 %</td><td>70,36 %</td><td>76,52 %</td><td>66,25 %</td><td>47,66 %</td><td>27,29 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>-96,72 %</td><td>6,58 %</td><td>74,51 %</td><td>78,72 %</td><td>55,36 %</td><td>28,17 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>21,05 %</td><td>0,04 %</td><td>0,10 %</td><td>2,43 %</td><td>1,13 %</td><td>0,59 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>28,16 %</td><td>45,96 %</td><td>24,97 %</td><td>15,79 %</td><td>14,24 %</td><td>14,08 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>25,36 %</td><td>5,14 %</td><td>0,10 %</td><td>0,28 %</td><td>1,34 %</td><td>1,09 %</td></tr>
</tbody>
</table>

## Comparing random read bandwidth

<style type="text/css">
#carousel-bw-randread .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-bw-randread .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-bw-randread" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-bw-randread" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/bw-randread-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randread-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-bw-randread" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-bw-randread" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses random read bandwidth

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>25,82 %</td><td>0,68 %</td><td>5,07 %</td><td>5,01 %</td><td>1,41 %</td><td>6,52 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>-0,13 %</td><td>1,14 %</td><td>8,37 %</td><td>6,49 %</td><td>2,09 %</td><td>2,27 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>16,07 %</td><td>28,12 %</td><td>75,55 %</td><td>79,59 %</td><td>68,01 %</td><td>57,02 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>17,70 %</td><td>17,95 %</td><td>74,13 %</td><td>70,29 %</td><td>65,40 %</td><td>55,81 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>0,30 %</td><td>-2,29 %</td><td>-3,12 %</td><td>-10,31 %</td><td>-0,86 %</td><td>4,27 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>1,94 %</td><td>-0,09 %</td><td>-1,43 %</td><td>-0,37 %</td><td>0,41 %</td><td>0,33 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>39,76 %</td><td>50,71 %</td><td>50,76 %</td><td>48,91 %</td><td>48,58 %</td><td>48,48 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>44,52 %</td><td>13,26 %</td><td>2,84 %</td><td>2,23 %</td><td>2,38 %</td><td>3,05 %</td></tr>
</tbody>
</table>

## Comparing random write bandwidth

<style type="text/css">
#carousel-bw-randwrite .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-bw-randwrite .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-bw-randwrite" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/bw-randwrite-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/bw-randwrite-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-bw-randwrite" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses random write bandwidth

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>-21,21 %</td><td>0,45 %</td><td>27,20 %</td><td>25,34 %</td><td>34,89 %</td><td>43,14 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>-6,72 %</td><td>6,91 %</td><td>11,24 %</td><td>19,57 %</td><td>12,97 %</td><td>9,49 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>54,45 %</td><td>72,75 %</td><td>83,56 %</td><td>81,83 %</td><td>60,73 %</td><td>32,43 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>53,20 %</td><td>73,91 %</td><td>76,44 %</td><td>61,98 %</td><td>50,27 %</td><td>27,10 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>-0,23 %</td><td>0,38 %</td><td>20,77 %</td><td>18,22 %</td><td>15,83 %</td><td>19,05 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>2,17 %</td><td>-9,64 %</td><td>4,78 %</td><td>4,98 %</td><td>2,51 %</td><td>2,56 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>21,03 %</td><td>37,76 %</td><td>21,16 %</td><td>12,26 %</td><td>13,00 %</td><td>13,06 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>22,75 %</td><td>8,13 %</td><td>5,57 %</td><td>2,78 %</td><td>4,58 %</td><td>3,51 %</td></tr>
</tbody>
</table>

## Comparing read IOPS

<style type="text/css">
#carousel-iops-read .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-iops-read .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-iops-read" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-iops-read" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/iops-read-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-read-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-iops-read" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-iops-read" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses read IOPS

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>10,82 %</td><td>32,48 %</td><td>47,36 %</td><td>52,95 %</td><td>36,26 %</td><td>3,86 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>23,86 %</td><td>-0,06 %</td><td>-0,02 %</td><td>0,01 %</td><td>-0,05 %</td><td>-0,08 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>45,53 %</td><td>70,13 %</td><td>77,05 %</td><td>80,61 %</td><td>67,65 %</td><td>55,88 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>44,42 %</td><td>71,76 %</td><td>67,46 %</td><td>70,75 %</td><td>63,21 %</td><td>53,24 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>6,81 %</td><td>13,71 %</td><td>4,92 %</td><td>2,66 %</td><td>9,81 %</td><td>23,52 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>14,75 %</td><td>-0,65 %</td><td>-0,03 %</td><td>-0,03 %</td><td>0,21 %</td><td>0,13 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>40,99 %</td><td>60,02 %</td><td>51,61 %</td><td>49,68 %</td><td>48,62 %</td><td>48,62 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>40,64 %</td><td>21,57 %</td><td>1,89 %</td><td>1,89 %</td><td>1,98 %</td><td>2,43 %</td></tr>
</tbody>
</table>

## Comparing write IOPS

<style type="text/css">
#carousel-iops-write .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-iops-write .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-iops-write" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-iops-write" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/iops-write-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-write-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-iops-write" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-iops-write" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses write IOPS

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>-499,50 %</td><td>11,31 %</td><td>31,52 %</td><td>34,98 %</td><td>28,53 %</td><td>49,55 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>-59,93 %</td><td>-1,32 %</td><td>0,05 %</td><td>10,11 %</td><td>12,43 %</td><td>10,18 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>51,45 %</td><td>71,81 %</td><td>82,63 %</td><td>82,36 %</td><td>69,05 %</td><td>44,83 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>56,11 %</td><td>70,36 %</td><td>76,52 %</td><td>66,25 %</td><td>47,66 %</td><td>27,29 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>-96,72 %</td><td>6,58 %</td><td>74,51 %</td><td>78,72 %</td><td>55,36 %</td><td>28,17 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>21,05 %</td><td>0,04 %</td><td>0,10 %</td><td>2,43 %</td><td>1,13 %</td><td>0,59 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>28,16 %</td><td>45,96 %</td><td>24,97 %</td><td>15,79 %</td><td>14,24 %</td><td>14,08 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>25,36 %</td><td>5,14 %</td><td>0,10 %</td><td>0,28 %</td><td>1,34 %</td><td>1,09 %</td></tr>
</tbody>
</table>

## Comparing random read IOPS

<style type="text/css">
#carousel-iops-randread .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-iops-randread .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-iops-randread" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-iops-randread" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/iops-randread-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randread-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-iops-randread" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-iops-randread" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses random read IOPS

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>25,82 %</td><td>0,68 %</td><td>5,07 %</td><td>5,01 %</td><td>1,41 %</td><td>6,52 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>-0,13 %</td><td>1,14 %</td><td>8,37 %</td><td>6,49 %</td><td>2,09 %</td><td>2,27 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>16,07 %</td><td>28,12 %</td><td>75,55 %</td><td>79,59 %</td><td>68,01 %</td><td>57,02 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>17,70 %</td><td>17,95 %</td><td>74,13 %</td><td>70,29 %</td><td>65,40 %</td><td>55,81 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>0,30 %</td><td>-2,29 %</td><td>-3,12 %</td><td>-10,31 %</td><td>-0,86 %</td><td>4,27 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>1,94 %</td><td>-0,09 %</td><td>-1,43 %</td><td>-0,37 %</td><td>0,41 %</td><td>0,33 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>39,76 %</td><td>50,71 %</td><td>50,76 %</td><td>48,91 %</td><td>48,58 %</td><td>48,48 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>44,52 %</td><td>13,26 %</td><td>2,84 %</td><td>2,23 %</td><td>2,38 %</td><td>3,05 %</td></tr>
</tbody>
</table>

## Comparing random write IOPS

<style type="text/css">
#carousel-iops-randwrite .carousel-indicators button {
color: #fff;
background-color: #fff;
}
#carousel-iops-randwrite .carousel-indicators button.active {
color: #e9c53c;
background-color: #e9c53c;	
}	
</style>
<div id="carousel-iops-randwrite" class="carousel carousel-dark slide" data-bs-ride="false">
<div class="carousel-indicators">
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 0"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="1"  aria-current="true" aria-label="Slide 1"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="2"  aria-current="true" aria-label="Slide 2"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="3"  aria-current="true" aria-label="Slide 3"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="4"  aria-current="true" aria-label="Slide 4"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="5"  aria-current="true" aria-label="Slide 5"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="6"  aria-current="true" aria-label="Slide 6"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="7"  aria-current="true" aria-label="Slide 7"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="8"  aria-current="true" aria-label="Slide 8"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="9"  aria-current="true" aria-label="Slide 9"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="10"  aria-current="true" aria-label="Slide 10"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="11"  aria-current="true" aria-label="Slide 11"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="12"  aria-current="true" aria-label="Slide 12"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="13"  aria-current="true" aria-label="Slide 13"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="14"  aria-current="true" aria-label="Slide 14"></button>
<button type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide-to="15"  aria-current="true" aria-label="Slide 15"></button>
</div>
<div class="carousel-inner">
<div class="carousel-item active">{% asset 'blog/luks-perf/iops-randwrite-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-sas-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-sas-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-sas-hdd-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-sas-hdd-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-nvme-raid0-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-nvme-raid0-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-nvme-non-encrypt.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
<div class="carousel-item">{% asset 'blog/luks-perf/iops-randwrite-iod32-nvme-encrypted.png' class="d-block w-100 mx-auto" style="max-width: 654px;" %}</div>
</div>
<button class="carousel-control-prev" type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide="prev">
<span class="carousel-control-prev-icon" aria-hidden="true"></span>
<span class="visually-hidden">Previous</span>
</button>
<button class="carousel-control-next" type="button" data-bs-target="#carousel-iops-randwrite" data-bs-slide="next">
<span class="carousel-control-next-icon" aria-hidden="true"></span>
<span class="visually-hidden">Next</span>
</button>
</div>
<p class="text-center fw-semibold">Caution: Scales are logarithmic!</p>

### Performance losses random write IOPS

<table class="table table-striped table-hover table-bordered">
<thead>
<tr>
<th scope="col">Device</th>
<th scope="col">4 KiB % loss</th>
<th scope="col">64 KiB % loss</th>
<th scope="col">1 MiB % loss</th>
<th scope="col">4 MiB % loss</th>
<th scope="col">16 MiB % loss</th>
<th scope="col">64 MiB % loss</th>
</tr>
</thead>
<tbody>
<tr><th scope="row">SAS RAID-0</th>            <td>-21,21 %</td><td>0,45 %</td><td>27,20 %</td><td>25,34 %</td><td>34,89 %</td><td>43,14 %</td></tr>
<tr><th scope="row">SAS HDD</th>               <td>-6,72 %</td><td>6,91 %</td><td>11,24 %</td><td>19,57 %</td><td>12,97 %</td><td>9,49 %</td></tr>
<tr><th scope="row">NVME RAID-0</th>           <td>54,45 %</td><td>72,75 %</td><td>83,56 %</td><td>81,83 %</td><td>60,73 %</td><td>32,43 %</td></tr>
<tr><th scope="row">NVME</th>                  <td>53,20 %</td><td>73,91 %</td><td>76,44 %</td><td>61,98 %</td><td>50,27 %</td><td>27,10 %</td></tr>
<tr><th scope="row">SAS RAID-0 iodepth=32</th> <td>-0,23 %</td><td>0,38 %</td><td>20,77 %</td><td>18,22 %</td><td>15,83 %</td><td>19,05 %</td></tr>
<tr><th scope="row">SAS HDD iodepth=32</th>    <td>2,17 %</td><td>-9,64 %</td><td>4,78 %</td><td>4,98 %</td><td>2,51 %</td><td>2,56 %</td></tr>
<tr><th scope="row">NVME RAID-0 iodepth=32</th><td>21,03 %</td><td>37,76 %</td><td>21,16 %</td><td>12,26 %</td><td>13,00 %</td><td>13,06 %</td></tr>
<tr><th scope="row">NVME iodepth=32</th>       <td>22,75 %</td><td>8,13 %</td><td>5,57 %</td><td>2,78 %</td><td>4,58 %</td><td>3,51 %</td></tr>
</tbody>
</table>


## Conclusion
<p class="lead">
Although modern CPUs provide AES acceleration through AES-NI instructions, the overall performance penalty especially when using NVME drives is too big to recommend turning it on everywhere.
</p>

Self encrypting drives technically work but the tooling around them is still in its infancy and as of yet not suitable for use in a DC environment until server manufacturers incorporate the necessary options in their firmware and the tools for managing SEDs under linux significantly improve in documentation and user friendliness.

SEDs also suffer in the aspect of having to trust that the drive manufacturer implemented the cryptography correctly and didn't add backdoors into it. Recent history has shown that this isn't always the case as some (albeit consumer grade) SSDs didn't encrypt data at all and even allowed access without knowing the passphrase.  
(This was a problem with e.g. Microsoft's BitLocker relying on the drive to perform the cryptography and afaik subsequently was fixed by Microsoft.) 

Crypto accelerators could be a solution here, however it'd be nice to see that technology embedded into servers directly since cryptography nowadays is a must-have.

<p class="lead fw-semibold">Thank you for reading this blog post!</p>
