---
layout: post
title: "Preferring diskless flavors in SCS"
author:
  - "Kurt Garloff"
avatar:
  - "avatar-garloff.jpg"
#image: "blog/ciab/first.jpg"
---

## Flavor standardization

SCS offers the promise to make it easy for Cloud users (typically DevOps teams
that develop and operate services / workloads on top of SCS IaaS and/or
Container infrastructure) to move between different SCS enviroments and vendors
or to use several of them in a federated way. One of the eearly accomplishments
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
In versions 1 and 2 of the flavor standard, the SCS community has tried to
prevent flavor explosion by just mandating one disk size per flavor, scaling
it with the size of the RAM and chosing discete values of 5, 10, 20,
50 and 100 GB for them. (By extension, providers that want to provide
larger disks have been advised to choose 200, 500, 1000, ... GB for these.)

Next to the each flavor with a root disk size (e.g. `SCS-4V-16-50`), SCS
also mandates a flavor without a root disk (e.g. `SCS-4V-16`). This is useful,
as OpenStack also allows users to allocate block storage (a virtual disk) with
arbitrary size upon VM creation, although it is a bit more complicated (see
below). So we have one disk size per vCPU-RAM combination for simplicity
and the flexibility to have an arbitrary disk size with a bit more effort.
This is what we had for the SCS flavor standards v1 and v2.

With v3, we also added two flavors with (at least) SSD type root disk storage.
Adding all combinations here would have again resulted in many new flavors.
Yet the cloud operators in the SCS community really wanted to avoid a
proliferation of many new flavors mandated by the standards. The SCS community
agreed on avoiding more mandatory flavors and instead stopped mandating
the flavors with disks (except for the two new ones with SSDs, more on this
later).

With the SCS flavor standard v3, the formerly mandatory flavors with disk
have been downgraded to recommended. Operators still should provide them for
best portability of apps written against older SCS standards, but they are no
longer required to in order to be able to achieve the SCS-compatible certification
on the IaaS layer. We recommend developers to use the diskless flavors and
allocate root disks dynamically.

The next section explains how this can be done and uses examples from SCS'
own projects.

## Creating VMs with diskless flavors

### Horizon
### API
### openstack-cli
#### Example: openstack-health-monitor
### terraform
### OCCM
#### Example: k8s-cluster-api-provider

## Why create the two (new) SSD flavors?

