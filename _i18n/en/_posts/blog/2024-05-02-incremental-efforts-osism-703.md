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

* Backport of [https://review.opendev.org/c/openstack/octavia/+/896995](https://review.opendev.org/c/openstack/octavia/+/896995) to fix errors when deleting LB with broken amphorae.

* Bugfix for [OSISM#890](https://github.com/osism/issues/issues/890) (octavia (ovn) does not find existing subnet) by enabling the use of the custom CA for octavia user session queries with the following PR: https://github.com/osism/container-images-kolla/pull/412

A plethora of fixes and additions were done since the 7.0.2 release a few weeks ago - as such today 7.0.3 was released by the OSISM team.

## OSISM 7.0.3

While OSISM 7.0.3 does not yet bring a fix for the leaking of octavia ports that was reported in [OSISM#921](https://github.com/osism/issues/issues/921) since this is pending some upstream work, it does bring a fix for a [bug when creating a fully-populated LB with allowed_cidr](https://bugs.launchpad.net/octavia/+bug/2057751).

Alongside this bugfix the next minor release of OSISM brings the following noteworthy items to the table:

* During the preparation of the upgrades of the regions of the PCO a bug ([osism/issues#937](https://github.com/osism/issues/issues/973)) has been noticed which leads to a delay of up to 2 minutes between the necessary container stops and starts. This is due to a bug in the service units of all Kolla services. The bug is fixed in the current release. To avoid the delay during an upgrade, a fix must be applied in advance for all srvice units from Kolla: `$ osism apply fix-gh937`.
* The `ceph_cluster_fsid` parameter is now generated automatically. It can be removed from `environments/configuration.yml`. The automatically generated `ceph_clusterfs_fsid` parameter is set to the value of the `fsid` parameter from `environments/ceph/configuration.yml`.
* Versions not yet pinned in the manager environment of the configuration repository (Ansible collections, `osism/cfg-generics`, ..) are now automatically pinned during synchronisation with gilt overlay. This also applies to the osism update manager script.
* The Docker version and the Docker CLI version can now also be managed via `osism/cfg-generics`. It is recommended to pin the Docker version in `environments/configuration.yml`.
* Monitoring services are now activated by default for the internal Kubernetes cluster.
* Kubernetes Cluster API for the 1.30 series is available. They are now provided directly with `osism manage image clusterapi`. This means that Kubernetes Cluster API images are now available for series 1.27, 1.28, 1.29 and 1.30.
* All Ansible collections have been prepared for use with Ubuntu 24.04. It is currently not recommended to upgrade existing clusters to Ubuntu 24.04 or to install new clusters with Ubuntu 24.04. There will be a note in the release notes from which Ubuntu 24.04 can be used.

This list is by far not complete, a complete list is part of the release notes are available on [releases.osism.tech](https://release.osism.tech/notes/7.html).

Important note: The OpenStack service images for Octavia and Nova have been rebuilt. Upgrades of the Octavia and Nova services are recommended. No upgrades of other OpenStack and associated infrastructure services such as MariaDB or RabbitMQ are required.
