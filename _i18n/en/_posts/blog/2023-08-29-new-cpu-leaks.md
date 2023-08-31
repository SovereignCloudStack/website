---
layout: post
title: "New CPU leaks (August 2023)"
author:
  - "Kurt Garloff"
  - "Dominik Pataky"
avatar:
  - "kgarloff.jpg"
  - "bitkeks.png"
about:
  - "garloff"
image: "blog/cpu/downfall.png"
---

## Summary

A new set of hardware CPU speculation vulnerabilities were uncovered in
July/August 2023. They do create risks for information disclosure for 
providers and users of SCS clouds. This blog article explains the issues,
the associated risks and how these can be mitigated by providers and users.

## CPU leak introduction and history

In January 2018, a new class of hardware vulnerabilities became publicly known.

Modern CPUs have the capability to do an amazing amount of things in parallel.
While they are calculating the result of one operation, they are already executing
instructions that occur afterwards. This is necessary for high performance, because
some operations take longer than others. And more importantly, if data is not available
in the CPU registers or caches, it may take way beyond 100 CPU cycles to get them
from main memory (RAM). CPUs would be rather slow if they would incur many cache
misses and then sit idle at each cache or worse translation lookaside buffer (TLB) miss.
Good cache handling is thus part of every modern CPU design.

Some instructions depend on results of previous instructions. The code flow does often
depend on such results (conditional branches). If the CPU wants to execute these
instructions despite some previous instruction whose result is needed not yet being
complete, it can speculate on the outcomes (for example based on previous results).
CPUs have lots of specialized hardware to do this speculation well: branch predictors,
return stack buffers, etc.

Nevertheless misspeculation can happen of course. When it does, the CPU needs to
carefully rewind the state and undo everything that has happened after a mispredicted
speculation. Results need to be discarded and the state of registers and memory
be reinstated from before the misprediction. Failures to do so would cause unpredictable
CPU behaviors and be very serious CPU bugs. CPU vendors are good at avoiding this.

However, even if the official architectural state of the CPU is correctly reinstated
after misspeculation, there may be traces from the misspeculation, such as internal
CPU buffers and caches, the microarchitectural state, that have a different state.
While these states should not influence the outcome of future operations, they may
be observable, e.g. by timing effects. Authors of code that handles cryptography have
thus learned to avoid writing code that has code paths or execution times that depend
on keys or sensitive data. With misspeculation this however is at the mercy of the
CPU -- as misspeculation might depend on sensitive data, we may have a potential
side-channel that can leak such data.

A program could observe misspeculation and thus take conclusions from data in other
parts of the same program -- not normally an issue, unless the program is specifically
designed to create sandboxes for executing untrusted code. Browsers do this for
example to execute JavaScript code in a somewhat secure way.

Things become more serious if microarchitectural state survives a context switch.
When the operating system switches between processes or a hypervisor between
virtual machines, we'd definitely like to be sure that no data can be observed.
However, discarding all state (e.g. all internal buffers, branch history, caches,
TLB, ...) upon each context switch would result in bad context switching performance,
so CPUs try to limit this.

Worse, CPUs with Simultaneous MultiThreading (SMT -- called HyperThreading in
the x86 world) have two (or more) logical CPUs that share a lot of CPU core components (register files, execution units, prediction buffers, ...)
and thus microarchitectural state. One logical CPU may however execute code from
a different process or a virtual machine from a different user than the other logical
CPU sharing the same core. This creates a significant risk for side-channel
leaking data and extra care from an operating system or hypervisor with context switches may not be effective.

All these vulnerabilities share the property that they can cause data leaks.
An attacker tricks the CPU into speculation and then observes microarchitectural
state from a different security context. While no data can be changed and corrupted
this way, sensitive data (e.g. encryption keys or passwords) can be leaked.
So all of these are Information Disclosure vulnerabilities.

When such vulnerabilities were reported, mitigating measures were developed by
kernel developers and CPU vendors. The low-level operation of some of the more
complex operations of CPUs is programmable by so called microcode (µcode), which
can be updated by the BIOS or by the operating system during the boot process.
In theory, it can also be updated later on -- however, it is very
difficult to do this in a safe way and thus unsupported for most setups.
Some of the leaks can be fixed by µcode updates -- typically at the cost
of performance, sometimes very significantly so. So these security protecting
features may be designed as opt-in features or may just enable new features
that the hypervisor or kernel can then use for mitigation.

The operating system kernel and hypervisor
on the other hand can use extra instructions to do cleanup on context switches,
prevent certain speculation at sensitive places or place extra instructions
to prevent microarchictectural state from one logical CPU to influence another.
Operating systems/hypervisors may avoid scheduling VMs from different users
on the logical cores (group scheduling) of a shared CPU core or disable SMT
alltogether.
Compilers may support with placing extra instructions in identifying sensitive
places and in placing extra instructions there. Obviously, these mitigations
also typically come with a performance cost -- also a very significant one
for some. Operating system and hypervisor developers also tend to allow
opt-out for these protections.

The stream of vulnerabilities since the original Meltdown and Spectre reports
has kept CPU vendors and OS developers busy.

One extremely useful tool to know is the
[spectre-meltdown-checker.sh](https://github.com/speed47/spectre-meltdown-checker).
When executed (with root privileges) on a host, it checks whether your CPU
is susceptible to various vulnerabilities and informs you about the mitigation
status. There's one limitation that you should be aware of:
When running the tool inside a virtual machine, it can not comprehensively
determine how well the hypervisor protects against these speculative data leaks
between virtual machines.

## New CPU leaks July/August 2023


| Name | Website | CVE | CPUs | CVSS |
| :--- | :--- | :--- | :--- | :--- |
| Zenbleed | [lock.cmpxchg8b.com](https://lock.cmpxchg8b.com/zenbleed.html) |  [CVE-2023-20593](https://nvd.nist.gov/vuln/detail/CVE-2023-20593) | AMD Zen 2 / EPYC Rome 7xx2 | 5.5 |
| Inception | [comsec.ethz.ch](https://comsec.ethz.ch/research/microarch/inception/) | [CVE-2023-20569](https://nvd.nist.gov/vuln/detail/CVE-2023-20569) | AMD Zen 1-4 / EPYC xxx[1-4] | 7.5 |
| Downfall | [downfall.page](https://downfall.page) | [CVE-2022-40982](https://nvd.nist.gov/vuln/detail/CVE-2022-40982) | Intel Core Skylake (6th) to Tiger Lake (11th), Xeon 1st to 4th | 6.5 |
| div0 | [git.kernel.org](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f58d6fbcb7c848b7f2469be339bc571f2e9d245b) | - | AMD Zen 1 / EPYC Naples 7xx1 | - |


### Zenbleed (Zen 2)
This vulnerability was discovered by Tavis Ormandy from Google, is catalogued as
CVE-2023-20593 and became public on July 25.
The AVX vector unit of affected processors does speculatively
execute depending on the parts of vectors registers that should have been
cleared by `vzeroupper`. As AVX registers are used commonly for copying
or analysing data (such as e.g. in glibc's `strlen()` routine),
chances that these contain valuable data such as e.g. passwords
are significant. This vulnerability only affects AMD processors with the
Zen 2 architecture (such as e.g. EPYC Rome or Zen 3000 desktop processors,
Zen 4000 and confusingly also some Zen 5000U and 7020 processors which
are also using the old Zen 2 architecture). Access to the system is
required to exploit this vulnerability.

The issue is described well [here](https://lock.cmpxchg8b.com/zenbleed.html).

AMD has provided updated microcode to address this; while updated
`linux-firmware` contains these microcode updates for EPYC Rome server processors,
desktop/laptop users will need to wait for BIOS updates with updated
AGESA versions to get the fixes. Until this happens, the Linux kernel
since version 6.4.6, 6.1.41 and 5.15.122 does set an MSR bit that disables certain
AVX features which causes performance degradation but avoids the issue.
The author is not aware of performance measurements done with this
mitigation.

### Inception aka SRSO (Zen 1-4)
Researchers from ETH Zürich have found a new vulnerability in AMD Zen 1, 2, 3, 4
processors. They abuse Phantom speculation [CVE-2022-23825](https://www.cve.org/CVERecord?id=CVE-2022-23825)
where these Zen processors "dream" about a branch instruction where none
exists. The researchers are able to inject more predictions into the
branch predictor during the misspeculation window (before the CPU
notices that its dreaming and cleans up on awaking), so that the
phantom speculation becomes possible to abuse. This is called
after the inception movie where ideas are injected during a victim's
dream. It's described well in their [publication](https://comsec.ethz.ch/research/microarch/inception/).
The researchers have been able to create a flow where a harmless
`XOR` instruction turns into a misspeculation to become a recursive call,
overflowing the return stack buffer (RSB) with an attacker controlled
value that will be speculatively jumped to upon the next `RET` instruction.
The alternative name Speculative Return Stack Overflow (SRSO) is thus used
as well. Inception was published on August 8 and has been assigned
[CVE-2023-20569](https://cve.mitre.org/cgi-bin/cvename.cgi?name=2023-20569).

This again allows attackers to access data across contexts (such as address
spaces, privileged modes, virtualization boundaries).

Mitigating is hard -- flushing the complete branch predictor when switching
between untrusted contexts comes with a hefty performance penalty.
The complete flush is only possible with Zen 1 and Zen 2 CPUs; for Zen 3
and Zen 4, new microcode is required to do safe flushing with `IBPB`.
This is used to protect the KVM hypervisor.

A different approach has been taken in the Linux kernel. Channeling all
returns there into a single location `__x86_return_thunk`, the branch predictor
state can be ensured to have a safe (yet wrong) state. This also comes with
[significant performance implications](https://www.phoronix.com/review/amd-inception-benchmarks),
though less than using the `IBPB` instruction to flush branch predictors
for most workloads. The performance hit is negligible for number-crunching
workloads (which are running in user-space mode most of the time) and
becomes bad (>20%) on I/O heavy workloads.

The fixes are included in Linux kernel 6.4.9, 6.1.44 and 5.15.125.

Note that the fixes are being reworked currently to not interfere with
the retbleed mitigation which they resemble. It is however believed that
the cleanup work will not change the performance impact nor effectiveness
of the mitigation. The first set of improvements are part of Linux 6.4.12, more are being worked on.

### Div-by-Zero (Zen 1)

On Zen-1 CPUs, under some circumstances, doing a division by zero
(which raises an exception) can expose the content of a previous
division and thus leak data.
This was reported with the [fix](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=77245f1c3c6495521f6a3af082696ee2f8ce3921) from Borislav Petkov from AMD. No further information
on the discovery was reported.

The first fix, included in above link was incomplete: While
flushing the divider by doing an extra 0/1 division in the exception
handler does its job, there is a time window where the exception
handler has not yet executed. To close this, [a follow-up patch](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f58d6fbcb7c848b7f2469be339bc571f2e9d245b)
added divider clearing on context switches, making sure that the
data leakage can not happen across domains.

The original fix was added to Linux 6.4.10, 6.1.45, 5.15.126.
The improved fix is in 6.4.12.

The performance impact of the mitigation is expected to be small.

### Downfall (Intel Core Skylake (6th) to TigerLake (11th) and Xeon 1st to 4th)

On August 8, a new vulnerability in the implementation of AVX data
gathering on Intel processors from Core Skylake till Tigerlake and Xeon
1st to 4th was published.
It was found a long time ago by Daniel Moghini and disclosed to Intel.
It was assigned [CVE-2022-40982](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-40982)
and the name [Downfall](https://downfall.page/)
is used to describe it.

When the AVX GATHER instructions are used to speed up access to data scattered in
memory, affected Intel CPUs transiently expose the contents of the internal
vector register file via speculative execution. This leads to data leakage,
potentially affecting sensitive data (like with Zenbleed) as AVX
is being used for `strlen()` and `memcpy()` in the glibc system library.
AVX registers are also used by cryptographic instructions.
Vector registers used in SGX enclaves also leak data.

The latest Intel processors (AlderLake / Sapphire Rapids) appear not to be
affected. A full list of affected Intel products is published by Intel as
[Affected Processors: Guidance for Security Issues on Intel® Processors](https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html)

Intel has released updated microcode for many of the affected CPUs.
With the fixes applied, memory access with AVX GATHER is slowed down
significantly, as can be seen from [benchmarks](https://www.phoronix.com/review/intel-downfall-benchmarks).
The impact is especially large for numbercrunching workloads which
tend to benefit from the full set of AVX capabilities.
A [patch to the GCC compiler](https://www.phoronix.com/news/GCC-Workaround-Intel-Downfall)
(version 14) allows users to avoid
generating GATHER instructions and using GATHER scalar emulation
instead. This should provide better performance on CPUs that are
affected and have the microcode fix.

On CPUs without microcode fix, the Linux kernel will switch off
AVX completely. This negates all optimizations from these vectorization
instructions, at a significantly higher cost to performance than
the microcode based mitigation. Handling Downfall was added to
the Linux kernel 6.4.9, 6.1.44, 5.15.125.


## Mitigation and SCS flavor policy

Linux distributors have published updated microcode (called
`linux-firmware`, `intel-microcode`, `amd-microcode` depending
on your distribution)) and updated kernels (which include the
KVM hypervisor) in the past weeks.
For the Ubuntu 22.04 LTS distribution normally used on
SCS installations, the updates to the Intel microcode, AMD
microcode are described in
[USN-6286-1](https://ubuntu.com/security/notices/USN-6286-1) and
[USN-6244-1](https://ubuntu.com/security/notices/USN-6244-1).
As of 2023-08-28, Ubuntu does seem to ship the software mitigation
for ZenBleed and Downfall, though not yet for SRSO (Inception)
with the 5.15.0-82 kernel built on August 14 and referenced in
[USN-6300-1](https://ubuntu.com/security/notices/USN-6300-1).
Canonical lists the kernel status for [ZenBleed](https://ubuntu.com/security/CVE-2023-20593),
[SRSO](https://ubuntu.com/security/CVE-2023-20593) and
[Downfall](https://ubuntu.com/security/CVE-2023-20593) as
Pending, Needs Triage and Needs Triage, so we'll probably
have to wait for at least the SRSO(Inception) kernel mitigation in
Ubuntu kernels for some more days.

SCS requires providers of SCS-compatible IaaS to deploy fixes
that are available upstream within a month of the availability.
This is mandated by the
[SCS flavor naming standard](https://docs.scs.community/standards/scs-0100-v3-flavor-naming#complete-proposal-for-systematic-flavor-naming)
-- by not using the `i` (for insecure) suffix, they commit to
keeping their compute hosts secured against such flaws by
deploying the needed microcode, kernel and hypervisor fixes
and mitigations.

Expect for users of the latest Intel server technology, pretty
much every server CPU is affected; expect your SCS providers to
reboot their compute hosts soon if they have not done so yet.
Thanks to live-migration, the impact to customers can be kept
rather limited, but most providers still announce such events
to their customers due to short-term performance degradation
and increased risk of VM failure during live migrations.

The above-mentioned spectre-meltdown-checker tool has been updated
to test for the new vulnerabilities except for the Div-by-0 (Zen 1)
issue, so cloud providers can use this to check whether their
deployment of microcode and hypervisor and kernel mitigations
have been successful.

## Keeping workloads secured

Users of cloud infrastructure are advised to keep their workloads
up-to-date with security updates. This means installing online
updates or redeploying workloads based on (new) images which are
up-to-date with respect to security fixes. Cloud providers often
provide standard Operating System images that can be a good basis
for deployments, customizing all configuration and software
installation by injecting user-data for cloud-init.

On SCS-compatible clouds, the
[SCS image metadata standard](https://docs.scs.community/standards/scs-0102-v1-image-metadata/)
allows users to see when the image has been built and what regular
update intervals are to be expected.

Of course, the cloud provider needs to do his part as well by
udpating microcode and hypervisors/kernels on the infrastructure
in a timely manner.
SCS providers will need to do so; in case of doubt, ask your
provider.

## CPU-based security issues: Outlook

We can expect that the reported CPU speculation vulnerabilities from this
summer were not the last ones to exist and to be uncovered.

One technology remains especially exposed to such vulnerabilities:
The usage of SMT in hypervisor host systems. Does the hardware of your
cloud provider use CPUs with SMT/HT? If yes, the
potential security impact might be increased due to more simultaneous access
to internal CPU resources (such as register files, buffers, caches, ...).
Security of sensitive workloads might therefore
benefit from disabling SMT alltogether. The loss of performance and
the decreased cost-benefit ratio for cloud service providers makes this
a not-so-attractive option for cloud providers though.

Cloud providers could offer flavors with dedicated cores, so no
workload with a different security context can run simultaneously on
a different thread of the same core. In SCS, flavors with a `C` CPU-suffix
provide dedicated hardware CPU cores for your workload. Example: the
flavor `SCS-4C-8` would create an instance with four of the host's
cores reserved solely for this single virtual machine. Currently, the
SCS standard does not mandate the availability of such dedicated core
flavors, so the support is cloud-dependant at this time.

Short of dedicated core flavors, you need rely on your cloud provider.
Establishing a good communication channel is a key factor in handling
security issues in a timely manner.

Using providers with an IaaS SCS-compatible certification and with
official SCS flavors (without the `i` = insecure CPU-suffix) gives you an
additional benefit: Cloud providers that offer SCS flavors have committed
themselves to apply security patches as soon as possible.

Using certified SCS providers is thus a reasonable protection against
such CPU weaknesses. If you have especially high protection requirements,
you might want to use flavors with dedicated cores or even build your own
private cloud environment -- hopefully on the same SCS technology
that allows you the full benefit of offering a full self-service cloud
internally and the benefit of easily connecting or even federating out
to public cloud SCS offerings.

## Links

* [Downfall and Zenbleed: Googlers helping secure the ecosystem ](https://security.googleblog.com/2023/08/downfall-and-zenbleed-googlers-helping.html)
* [Collide+Power, Downfall, and Inception: New Side-Channel Attacks Affecting Modern CPUs](https://thehackernews.com/2023/08/collidepower-downfall-and-inception-new.html)
* [LWN on Downfall and Inception](https://lwn.net/Articles/940783/) 
* [Phoronix update on Inception mitigation](https://www.phoronix.com/news/Linux-x86-bugs-AMD-SRSO)
* [iX article on Meltdown & Spectre from 2018](https://www.heise.de/select/ix/2018/2/1517770391119975) (German language)
