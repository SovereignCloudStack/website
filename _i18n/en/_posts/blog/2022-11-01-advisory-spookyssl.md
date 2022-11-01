---
layout: post
title:  "Sovereign Cloud Stack Security Advisory Spooky SSL"
category: security
author:
  - "Christian Berendt"
  - "Kurt Garloff"
avatar:
  - "CB.png"
  - "kgarloff.jpg"
<!--image: "blog/spookyssl.jpg"-->
---

## The vulnerability

On Tue, 2022-11-01, a vulnerability in the popular OpenSSL library
became publicly known. It affects OpenSSL-3.0.x versions prior
to the fixed version 3.0.7; older versions of OpenSSL (1.1.x
and earlier) are not affected.

<!--TODO: More details, CVE and links -->

https://github.com/NCSC-NL/OpenSSL-2022

## SCS reference implementation

The host images in the SCS reference implementation come from the
[OSISM](https://osism.tech) project and are all built on top of Ubuntu 20.04
LTS (focal). Ubuntu 20.04 uses OpenSSL-1.1.1 and is unaffected by the
vulnerability. The switch to Ubuntu 22.04 (jammy) which does use OpenSSL-3.0.x
was considered prior to SCS R3 (v4.0.0) but not executed due to technical
challenges and due to kolla not yet doing the switch.

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
language and are thus not using OpenSSL. The nginx container in the
nginx-ingress controller does use OpenSSL to support SSL termination
-- the container is built using Alpine-3.16 which uses
OpenSSL-1.1.1q and is thus not susceptible to this vulnerability.

<!--TODO: Check all containers and provide list-->

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
SCS recommends providing; it is affected by the OpenSSL-3 issue.
Other modern distributions (e.g. those based on RedHat Enterprise
Linux 9) are also affected; we recommend to use the list at
<https://github.com/NCSC-NL/OpenSSL-2022/blob/main/software/README.md>
to get a quick overview and to investigate yourself for the more
critical parts of applications.

We recommend to SCS operators to quickly replace the affected public images
with updated images as soon as the Linux distributors have provided updated
base images. Note that SCS has defined
[metadata](https://github.com/SovereignCloudStack/Docs/blob/main/Design-Docs/Image-Properties-Spec.md)
for images that allow users to see the build date. Any image that is older than
2022-11-01 and includes OpenSSL-3.0.x will very likely be vulnerable.

## Fixing applications

Affected VM-based applications that use automation for bootstrapping
may best use the new images and just redeploy to use the fixed OpenSSL
version. Otherwise an online update of the OpenSSL-3 library is recommended.
Not that applications need to be restarted to use the updated fixed
shared library. Applications that statically linked the vulnerable
OpenSSL-3.0.x (x<7) library need to be rebuilt using the fixed library
(3.0.7).

For container-based applications that built containers using affected
OpenSSL-3 libraries, rebuilding the containers with the fixed version
and redeploying them is recommended.

We recommend users to also review the workstations and laptops that are
used by their staff and to install available updates short-term.
Using Ubuntu 22.04 or other modern Linux distributions is a popular
choice amongst technically minded engineers.

## Note

Not yet having done the switch to Ubuntu-22.04 resulted in the exposure
of providers using the SCS reference implementation to be minimal.
Similar to the ["dirty pipe"](https://scs.community/security/2022/03/07/advisory-dirty-pipe/)
case, our choice of technology turned out to be a lucky one.
We know that there is no guarantee for luck; we do ensure we can react
quickly and effectively when affected.

Images are built and tested nightly in the OSISM infrastructure; we had
prepared to push out new images within a day if we had been affected, so we
have prepared to react to issues like this.

## Sovereign Cloud Stack Security Contact

SCS security contact is <mailto:security@scs.community>, as published on
<https://scs.community/.well-known/security.txt>.

## Version history

* Initial release on 2022-11-01, 19:00 CET.
