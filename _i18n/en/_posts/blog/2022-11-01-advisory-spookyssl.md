---
layout: post
title:  "Sovereign Cloud Stack Security Advisory Spooky SSL"
category: security
author:
  - "Kurt Garloff"
  - "Christian Berendt"
  - "Felix Kronlage-Dammers"
avatar:
  - "kgarloff.jpg"
  - "CB.png"
  - "fkr.jpg"
about:
  - "garloff"
  - "fkr"
image: "blog/spooky.png"
---

## The vulnerability

On Tue, 2022-11-01, two vulnerabilities in the popular OpenSSL library
became publicly known. They affect OpenSSL-3.0.x versions prior
to the fixed version 3.0.7; older versions of OpenSSL (1.1.x
and earlier) are not affected.

There are two vulnerabilities in the X.509 certificate parsing code
for email addresses, CVE-2022-3602 and CVE-2022-3786. Both are described
in the [OpenSSL Security Advisory](https://www.openssl.org/news/secadv/20221101.txt).
Both can result in buffer overflows which can crash the application,
resulting in a denial-of-service. The possibility to put 4 attacker-controlled
bytes on the stack in CVE-2022-3602 might even result in remote code execution
scenarios, though commonly used stack overflow protections prevent this.
The effectiveness of the stack overflow protections has lead the severity
classification to be downgraded from CRITICAL to HIGH.

A good collection of information on these vulnerabilities can be found on
[Netherlands Cyber Security Centrum](https://github.com/NCSC-NL/OpenSSL-2022).

## SCS reference implementation

The host images in the SCS reference implementation come from the
[OSISM](https://osism.tech) project and are all built on top of Ubuntu 20.04
LTS (focal). Ubuntu 20.04 uses OpenSSL-1.1.1 and is unaffected by the
vulnerability. The switch to Ubuntu 22.04 (jammy) which does use OpenSSL-3.0.x
is planned for SCS R4 (v5.0.0, due in Mar 2023) and has not happened yet,
neither in the OSISM image build system nor in the one from the upstream kolla
project.

The deployment of SCS happens via deploying numerous infrastructure
and OpenStack services in containers. The OpenStack containers come from
the upstream kolla project which uses Ubuntu 20.04. We are in progress
of reviewing all non-kolla containers to ensure that none of them pull-in
dependencies on OpenSSL-3.

<!--TODO: OSISM to check all containers ...-->
<!--TODO: Add link to SBOM -->

The SCS reference implementation for Kubernetes container management deploys a
management host using Ubuntu 20.04 for bootstrapping and managing the
workload clusters. The workload clusters use node images that are built
by OSISM using Ubuntu 20.04. The contained Kubernetes services do not
pull in OpenSSL-3 either.

The container management solution allows to deploy a number of standard
services. Many of the services are built using the golang programming
language and are thus not using OpenSSL. 

Here is the list of services that can be deployed with the SCS cluster-API
container management solution and the openSSL status of these:

| Service        | OpenSSL version  | Notes                 |
|----------------|------------------|-----------------------|
| OCCM           | 1.1.1n           | Alpine 3.15.4         |
| cindercsi      | none             | golang                |
| calico         | 1.1.1k           | RHEL 8.6              |
| cilium         | 1.1.1f           | Ubuntu 20.04.5        |
| nginx-ingress  | 1.1.1q           | Alpine 3.16           |
| metrics        | none             | golang                |
| cert-manager   | none             | golang                |
| flux           | 1.1.1q           | Alpine 3.16.2         |

<!-- TODO: harbor -->

## Rebuilt containers

The SCS community is prepared to publish security updates.
For the containerized OSISM base-deployment, this means preparing updated
containers that can be deployed, replacing the old containers.

Preparing for the OpenSSL-3 vulnerability, the OSISM team has prepared
to publish a version v4.1.0 containing all security and important bug fixes
that have been collected since R3 (v4.0.0 on 2022-09-21).

The OpenSSL-3 vulnerability currently does not seem to require such a
point release. However, there is also a go security update currently
happening, suggesting that a point release may well be good idea.
This is currently under investigation -- future updates of this
advisory will contain updated information on this.

## Public VM images on SCS clouds

Most clouds provide public images for popular Linux distributions
as a convenience to their users. Ubuntu 22.04 is one of the images that
SCS recommends providing; [it is affected by the OpenSSL-3 issue](https://ubuntu.com/security/CVE-2022-3602).
Other modern distributions (e.g. those based on RedHat Enterprise
Linux 9) are also affected; we recommend to use the list at
<https://github.com/NCSC-NL/OpenSSL-2022/blob/main/software/README.md>
to get a quick overview and to investigate yourself for the more
critical parts of applications. The command `openssl version`
can be used to learn about the installed OpenSSL version.

We recommend to SCS operators to quickly replace the affected public images
as soon as the Linux distributors have provided updated base images.
Note that SCS has defined
[metadata](https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0102-v1-image-metadata.md)
for images that allow users to see the build date. Any image that is older than
2022-11-01 and includes OpenSSL-3.0.x will very likely be vulnerable.

## Fixing applications

Affected VM-based applications that are dynamically linked against OpenSSL and
use automation for bootstrapping may best just redeploy against the latest
images to use the fixed OpenSSL version. Otherwise an online update of the
OpenSSL-3 library is recommended. Note that applications need to be restarted
to use the updated fixed shared library. Applications that statically linked
the vulnerable OpenSSL-3.0.x (x<7) library need to be rebuilt using the fixed
library (3.0.7 or later).

For container-based applications that built containers using affected
OpenSSL-3 libraries, rebuilding the containers with the fixed version
and redeploying them is recommended.

Sidenote:
We also remind users to review the workstations and laptops that are
used by their staff and to install available updates short-term.

## Sovereign Cloud Stack Security Contact

SCS security contact is <mailto:security@scs.community>, as published on
<https://scs.community/.well-known/security.txt>.

## Version history

* Initial release on 2022-11-01, 18:45 CET.
