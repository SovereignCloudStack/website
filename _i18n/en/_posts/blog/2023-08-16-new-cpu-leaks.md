---
layout: post
title: "New CPU leaks (Aug 2023)"
author:
  - "Kurt Garloff"
  - "Dominik Pataky"
avatar:
  - "avatar-garloff.jpg"
#image: "blog/cpu/littleboy.jpg"
---

## CPU leak introduction and history

In January 2018, a new class of hardware vulnerabilities became publicly known.

Modern CPUs have the capability to do an amazing amount of things in parallel.
While they are calculating the result of one operation, they are already executing
instructions that occur afterwards. This is necessary for high performance, because
some operations take longer than others. And more importantly, if data is not available
in the CPU registers or caches, it may take way beyond 100 CPU cycles to get them
from main memory (RAM). CPUs would be rather slow if they would incur many cache
misses and then sit idle at each cache (or worse TLB) miss. Good cache handling is
thus part of every modern CPU design.

Some instructions depend on results of previous instructions. The code flow does often
depend on such results (conditional branches). If the CPU wants to execute these
instructions despite some previous instruction whose result is needed not yet being
complete, it can speculate on the outcomes (for example based on previous results).
CPUs have lots of specialized hardware to do this speculation well: branch predictors,
return stack buffers, etc.

Nevertheless misspeculation can happen of course. When it does, the CPU needs to
carefully rewind the state and undo everything that has happened after a mispredicted
speculation. Results need to be discarded and the state of registers, memory, ...
be reinstated from before the misprediction. Failures to do so would cause unpredictable
CPU behaviors and be very serious CPU bugs. CPU vendors are good at avoiding this.

However, even if the official (architectural) state of the CPU is correctly reinstated
after misspeculation, there may be traces from the misspeculation, such as internal
CPU buffers and caches (the microarchitectural state) that have a different state.
While these states should not influence the outcome of future operations, they may
be observable, e.g. by timing effects. Authors of code that handles cryptography have
thus learned to avoid writing code that has code paths or execution times that depend
on keys or sensitive data. With misspeculation this however is at the mercy of the
CPU -- as misspeculation might depend on sensitive data, we may have a potential
side-channel that can leak such data.

A program could observe misspeculation and thus take conclusions from data in other
parts of the program -- not normally an issue, unless the program is specifically
designed to create sandboxes for executing untrusted code. Browsers do this for
example to execute javascript code in a somewhat secure way.

Things become more serious if microarchitectural state survives a context switch.
When the operating system switches between processes or a hypervisor between
virtual machines, we'd definitely like to be sure that no data can be observed.
However, discarding all state (e.g. all internal buffers, branch history, caches,
TLB, ...) upon each context switch would result in bad context switching performance,
so CPUs try to limit this.

Worse, CPUs with Simultaneous MultiThreading (SMT -- called HyperThreading in
the x86 world) have two (or more) logical CPUs that share a lot of infrastructure
and thus microarchitectural state. One logical CPU may however execute code from
a different process or virtual machine from a different user than another logical
CPU sharing the same infrastructure. This creates a significant risk for side-channel
leaking data.

All these vulnerabilities share the property that they can cause data leaks.
An attacker tricks the CPU into speculation and then observes microarchitectural
state from a different security context. While no data can be changed and corrupted
this way, sensitive data (e.g. encryption keys or passwords) can be leaked.
So all of these are Information Disclosure vulnerabilities.

When such vulnerabilities were reported, mitigating measures were developed by
kernel developers and CPU vendors. The low-level operation of some of the more
complex operations of CPUs is programmable by so called microcode (µcode), which
can be updated by the BIOS or by the operating system during the boot process.
(Footnote: In theory, it can also be updated later on -- however, it is very
difficult to do this in a safe way and thus unsupported for most setups.)
Some of the leaks can be fixed by µcode updates -- typically at the cost
of performance, sometimes very signficantly so. So these security protecting
features may be designed as opt-in features.

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
...
...

spectre-meltdown-checker.sh

## New CPU leaks July/August 2023
### Zenbleed (Zen 2)
### Inception (Zen 1-4)
### Div-by-Zero (Zen 1)
### Downfall (Skylake -- TigerLake)

