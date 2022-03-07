---
layout: post
title:  "Sovereign Cloud Stack Security Advisory dirty pipe"
category: security
author: "Kurt Garloff"
avatar: "/assets/images/kgarloff.jpg"
image: "/assets/images/blog/pipe.jpg"
---

_(By Christian Berendt, Kurt Garloff, Felix Kronlage-Dammers)_

## The vulnerability

On Fri, 2022-03-07, a failure in the Linux kernel code to properly initialize
the flags field of pipe buffers became widely known as "dirty pipe" 
[CVE-2022-0847](https://seclists.org/oss-sec/2022/q1/170).
The issue had been discovered and responsibly disclosed by Max Kellermann
from IONOS SE.
The bug allows any local user on a system to overwrite data in any file
regardless of permissions and thus creates a trivial local root exploit.

The issue was exposed (not introduced) by kernel commit f6dd975583bd and
affects Linux kernels 5.8 and newer. It was fixed in 5.16.11, 5.15.25 and
5.10.102.

More details can be found on <https://dirtypipe.cm4all.com/>.

## SCS reference implementation

The SCS images used in the IaaS reference implementation (which are mostly
comprised of [OSISM](https://osism.tech) which itself is based on kolla-ansible)
are using Ubuntu 20.04 LTS. To the best of our knowledge, the 5.4.xxx kernels
used there are NOT affected by the issue. The exploit code fails. We are waiting
to get an [official announcement](https://ubuntu.com/security/CVE-2022-0847)
from Canonical.

The management host deployed by the automation for our cluster management is
also using an Ubuntu 20.04 LTS image by default -- it is thus not affected.
We use cluster-api images for the kubernetes clusters also provided by
[OSISM](https://minio.services.osism.tech/openstack-k8s-capi-images). These
are also built on top of Ubuntu 20.04 LTS and thus not affected either.

The cloud operators often provide popular Linux images for their customers.
Some of them are affected, e.g. Ubuntu 20.10, 21.04 and 21.10.
These will need to be replaced.

## SCS infrastructure

Neither the instances running nextcloud, mailman3 nor Jitsi nor our webserver
are running the vulnerable kernel versions.

## Mitigation and fix

At this time, for cloud providers using the SCS reference implementation,
we see no required actions to protect the infrastructure, as SCS reference
implementation does not use any images including affected kernels.

We recommend SCS operators to double check that no supporting system uses
a vulnerable kernel. Furthermore, operators may have chosen to newer kernels
(e.g. the hardware enablement series from Ubuntu) due to specific hardware
requirements. In both cases, we recommend a short-term risk assessment and
the scheduling of the installation of a fixed kernel.

Most cloud operators provide images for the most popular Linux operating
systems. We strongly recommend to replace them with updated images as soon
as the Linux distributors have provided updated base images (which is
the case for many distributors at this point).
Note that SCS has defined [metadata](https://github.com/SovereignCloudStack/Docs/blob/main/Design-Docs/Image-Properties-Spec.md)
for images that allow users to see the build date. Any image that's older than
2021-02-21 and has a Linux kernel version >= 5.8 will very likely
be vulnerable.

## Note

We are lucky fact that the Sovereign Cloud Stack reference implementation
is not affected by this high-risk vulnerability. Avoiding too many different
Linux distributions and choosing version with good long-term support were
deliberate choices, but of course these are no guarantee to not be affected.
They intended to ensure we can react quickly and effectively if affected.

Images are built and tested nightly in the OSISM infrastructure; we would have
pushed out new images within a day if we had been affected, so we have prepared
to react to issues like this. We will however use the opportunity to double-check
that our reactions would have worked.

## Sovereign Cloud Stack Security Contact

SCS security contact is <mailto:security@scs.community>, as published on
<https://scs.community/.well-known/security.txt>.

## Version history

* Initial release on 2022-03-07, 19:00 CET.
