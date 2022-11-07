---
layout: post
title:  "R3 is before R4"
category: tech
author:
  - "Felix Kronlage-Dammers"
  - "Kurt Garloff"
avatar:
  - "fkr.jpg"
  - "kgarloff.jpg"
---

## Looking towards Release 4

We've just [released the Release 3](https://scs.community/release/2022/09/21/release3/) and with that we immediately started our R4 cycle.
Of course there are certain topics that we carry over from R3, especially since we work in a very iterative way, these turnovers mark a good spot to actually look at what we want to achieve with the next release cycle. While the majority of planning is done in our team meetings, Kurt, Christian and Felix prepared some initial work.
For that we looked at the funding proposal, the groundwork for our funding by the BMWK, and matched that with the outcomes we've accomplished so far. Likewise we looked at the currently running tenders as well the ones we're planning to kick off over the period of the next four months, since those tenders will play into items we work on for R4.

Features, functionality and what they offer to SCS Operators and Users are the heart of development and the level on which we often discuss in the planning sessions. Features as part of user stories come together in epics.
When we look at SCS and the releases, we don't just want to "throw a bunch of features over the fence". We want to enable operators of cloud computing infrastructure, we want to provide building blocks for digital sovereignty for operators to provide innovative offers to their customers. The outcomes for our stakeholders, primarily the operators, is what we focus on when describing our goals for R4.

SCS is comprised of three pillars: Standards, Reference Implementation and Open Operations. The outcomes for Release 4 are, obviously, aligned along those pillars.

### [SCS is standardized](https://github.com/orgs/SovereignCloudStack/projects/6/views/23)

One of the big rocks for Release 4 will be bringing our [Cluster standardization](https://github.com/SovereignCloudStack/issues/issues/181) forward. However our standardization efforts are comprised of many efforts -- we need to standardize the parameters that the cluster consumers can choose, the way how these are fed to the service to create and manage the k8s clusters and last not least the properties of the resulting clusters. The foundational work for this is the [current effort](https://github.com/SovereignCloudStack/Docs/pull/143) to have a formalized process of documenting these standard as well as our (design) decisions.

### [SCS is federated](https://github.com/orgs/SovereignCloudStack/projects/6/views/18)

While there were efforts done during the R2 and R3 cycles to work towards federated environments, as also shown [during the last GAIA-X hackathon](https://scs.community/2022/09/28/gaia-x-hackathon-5/) there will be lot's of activity on federation during the Release 4 cycle. With a [fantastic workshop](https://input.osb-alliance.de/p/2022-10-scs-iam-workshop) with members of The SIG (Special Interest Group) IAM as well as further members of our community we kicked this off in the first week of the R4 cycle.

### [SCS is continuously built and tested](https://github.com/orgs/SovereignCloudStack/projects/6/views/21)

The R3 cycle has - once again ;) - shown how important a very good continuous integration is. With SCS we want to enable operators to keep their environments constantly up to date with confidence.
The fact that two of our operators were able to directly upgrade to Release 3 shows that we're on the right track.

### [SCS is understandable](https://github.com/orgs/SovereignCloudStack/projects/6/views/22)

One of the areas where we've not advanced as much as we wanted is to lower the entry barrier to SCS and the reference implementation. However if we talk about "SCS is understandable" this shall not be reduced to our reference implementation. Our standards need to be easily understood as well, since this will lead to much better adoption. SCS being understandable is more than just mere documentation. There could be no better timing for our new colleague, Max Wolfs, to have joined the SCS team as our Knowledge Management Engineer.

### [SCS enables Operators with an excellent toolbox](https://github.com/orgs/SovereignCloudStack/projects/6/views/20)

For this to be viable an excellent toolbox is needed. Ranging from the [OpenStack Image Manager](https://github.com/osism/openstack-image-manager), our effort to [provide a status page application](https://github.com/SovereignCloudStack/issues/issues/123) to the Health Monitor.
The OpenStack Image Manager is the way to assure that a cloud, based on the IaaS reference implementation, carries the mandated images. Plans are to move the OpenStack Image Manager to a fully-fledged [OpenStack Swiss Army Knife](https://github.com/osism/issues/issues/317).

### [SCS helps to jump-start the Open Operations movement](https://github.com/SovereignCloudStack/open-operations-manifesto)

The need to share knowledge to operate complex infrastructure technology goes way beyond Sovereign Cloud Stack.
We want to help creating a broader movement that further develops the practices of collecting, sharing and exchanging operational experience.
