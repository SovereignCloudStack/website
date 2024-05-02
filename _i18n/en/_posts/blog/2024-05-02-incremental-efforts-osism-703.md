---
layout: post
title:  "Incremental efforts - OSISM 7.0.3 released"
category: tech
author:
- "Felix Kronlage-Dammers"
avatar:
- "fkr.jpg"
about:
- "fkr"
---

## Incremental efforts

One of the goals of the SCS project is enabling quick minor releases so that improvements
and benefits reach the operators as well as their customers faster.

With the [Release 6](https://scs.community/release/2024/03/20/release6/) earlier this year we did
note a [few known issues](https://github.com/SovereignCloudStack/release-notes/blob/main/Release6.md#list-of-known-issues--restrictions-in-r6)
that the release contains. On the [Infrastructure-as-a-Service](https://github.com/SovereignCloudStack/release-notes/blob/main/Release6.md#iaas-1)
layer this were:

* Creating loadbalancers in Cloud-in-a-Box installations fails with the
  error message that the VIP subnet does not exist. [OSISM #890](https://github.com/osism/issues/issues/890)
* When using `--provider ovn` with a loadbalancer health-monitor, we leak ports `ovn-lb-hm-$SUBNETID` in all
  but the VIP subnet, if we clean up the LB members before the health-monitor. This is tracked as
  [OSISM issue #921](https://github.com/osism/issues/issues/921). Deleting the health-monitor before the
  members or using `openstack loadbalancer delete --cascade` avoids this issue.
* With amphora loadbalancers, we can end up in situations that LB deletion does no longer work due to
  a failover or a failed creation of the vrrp port. This is tracked in
  [OSISM issue #925](https://github.com/osism/issues/issues/925). An upstream fix exists and a backport
  is already underway.

Quickly after the initial release OSISM released [7.0.1](https://release.osism.tech/notes/7.html#id2) that
contained a bugfixes for two of these issues:

* Backport of [https://review.opendev.org/c/openstack/octavia/+/896995](https://review.opendev.org/c/openstack/octavia/+/896995)
to fix errors when deleting LB with broken amphorae.

Bugfix for [OSISM#890](https://github.com/osism/issues/issues/890) (octavia (ovn) does not find existing subnet)
by enabling the use of the custom CA for octavia user session queries with the following PR: https://github.com/osism/container-images-kolla/pull/412

The third issue is part of the OSISM 7.0.3 release.

## OSISM 7.0.3

OSISM 7.0.3 is released and brings a fix for the leaking of octavia ports that was reported in [OSISM#921](https://github.com/osism/issues/issues/921).
Alongside this important bugfix the next minor release of OSISM brings the following noteworthy items to the table:

* ....

https://release.osism.tech/notes/7.html


