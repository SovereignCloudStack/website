---
layout: post
title:  "SCS is efficient to operate - R6 will enable you even better”
category: tech
author:
  - "Felix Kronlage-Dammers"
avatar:
  - "fkr.jpg"
about:
  - "fkr"
---

## Our R6 outcomes 

To better align the development efforts within our community we started working with *outcomes*.
We've started with this in the R4 cycle and even though we never published the outcomes for R5 - we [did have them for R5](https://github.com/SovereignCloudStack/website/pull/662) as well ;)

The idea of these outcomes is to outline what our (development) work does that enables our users (Operators, Integrators and End-Users) in the end to gain more value from SCS. This outlines our direction much better than talking about the next features that are planned and worked on. Furthermore, the outcomes assist us in our development work to ensure that every single epic and story we work on actually pays into the greater idea. 

SCS delivers building blocks for digital sovereign cloud infrastructure.  We change the way infrastructure is operated and by doing this we want to enable operators to become more efficient and be able to scale better.

#### Working with outcomes on GitHub

The outcomes allow us to look through various angles on our development efforts. Each outcome is reflected through a label within our GitHub repositories so that issues and pull requests can be labeled accordingly. Furthermore in the projects view we've added various filtered views to be able to quickly see which issues and working items play into which outcomes.

An [overall board](https://github.com/orgs/SovereignCloudStack/projects/6/views/28) summarizes all of them.


### [SCS is standardized](https://github.com/orgs/SovereignCloudStack/projects/6/views/23)

While the S in SCS (at least the first ;)) stands for *Sovereign* it could also stand for *Standardized*.
SCS standardizes. Creating Standards within the community, reaching out to surrounding communities, and working with upstream as well as other players in our ecosystem to make sure we don’t “just reinvent the wheel” or stew in their own juice is a fair share of our work within the project.
The recent [joint-efforts](https://scs.community/2023/11/27/joint-standardization/) with [ALASCA](https://alasca.cloud) emphasize this even more.

Alongside the standardization work that has happened in the container and IaaS teams the [tender 10](https://scs.community/tenders/lot10), an important tender package for the standardization work, was kicked off at the beginning of the R5 cycle. Through the work in the SIG Standardization, a lot of the topics have gained pace in the last months, yet this is one of the major topics for the R6 cycle.

Two issues summarize the current efforts quite well:

* [Missing IaaS Standards](https://github.com/SovereignCloudStack/standards/issues/285)
* [SCS K8s cluster standardization](https://github.com/sovereigncloudstack/issues/issues/181)

### [SCS is understandable](https://github.com/orgs/SovereignCloudStack/projects/6/views/22)

In the last year the [documentation page](https://docs.scs.community) came to life and is already very good in being the guide for the first steps into the SCS world. Due to the efforts of the SIG Documentation, it is not just a pile of documents but has a solid concept. However, for SCS to be understandable more than just awesome docs are needed. Collecting feedback from SCS integrators just as much as people and organizations that have their first touchpoint with SCS plays an important role in ensuring SCS is continuously becoming more understandable. Furthermore, deployment guides and architectural blueprints will be added.

For the IaaS reference implementation, a solid test of the existing documentation will be that the SCS lab environment will be built up following that documentation.

### [SCS enables](https://github.com/orgs/SovereignCloudStack/projects/6/views/20)

For the R4 development cycle one of the outcomes we proclaimed was *SCS enables Operators with an excellent toolbox*. An excellent toolbox is part of what is needed for operating cloud infrastructure as a commodity. Looking at what we’ve done in the past year this outcome however is much too narrow.
*SCS enables* - on a variety of levels and not just operators, but also integrators, developers, and most importantly consumers of cloud infrastructure built upon SCS who want to run on top of fully digital sovereign infrastructure.

With [Cluster Stacks](https://github.com/sovereignCloudStack/cluster-stacks), the V2 KaaS reference implementation, we provide an opinionated optimized configuration of Kubernetes clusters. Through better packaging, integrated testing, and bundled configuration SCS-based Kubernetes clusters can be individualized much easier.
Throughout the R6 development cycle Cluster Stacks are taken from a technical preview to be [functional and available on top of the IaaS reference implementation](https://github.com/SovereignCloudStack/issues/milestone/8) as well.
The Cluster Stacks can already be tried out in a [demo](https://github.com/SovereignCloudStack/cluster-stacks-demo). Although this is based on the non production ready provider Docker, the usage is the same for every provider.

Early in the R6 development cycle, the [software defined networking tender VP04](https://scs.community/tenders/lot4) was kicked of. As part of this work, we want to make sure that
networking not only scales superior in the IaaS reference implementation but also enables inter-cloud connectivity between
workloads on all layers.

Through GitHub, the [list of network-related epics and user stories](https://github.com/SovereignCloudStack/issues/issues?q=is%3Aopen+is%3Aissue+label%3ASCS-VP04) that are part of VP04 can be viewed.

With our work on the [domain manager role](https://github.com/SovereignCloudStack/issues/issues/184) we’re addressing a topic that has been a hurdle for public clouds and self-management by customers. Lots of public clouds, built on top of OpenStack, have developed their own ways to work around the missing possibility of domain management.

### [SCS is transparent](https://github.com/orgs/SovereignCloudStack/projects/6/views/30)

Transparency is one of the core values embedded in our project - yet we want to make sure our development efforts throughout the R6 cycle are actively working towards being transparent. This ranges from our development culture (which needs to be transparent not only to be trustworthy but also to lower the barrier to join the community) to the open operations movement, the future of the SCS project, and all the way to technical items such as [SBOMs](https://en.wikipedia.org/wiki/Software_supply_chain) for our complete stack.
Transparent projects can be audited easily and trust can be built up more easily.

Another important factor that plays into transparency is being transparent about security aspects, and incidents and proactively pursuing providing a secure reference implementation. 

For our status page initiative, an initial MVP was done in the R5 development cycle. In the R6 development cycle we [finalize](https://github.com/SovereignCloudStack/issues/issues?q=is%3Aopen+is%3Aissue+label%3Astatus-page) what we’ve evaluated with the MVP and are going to ship a modern status page application. The release of the status page application (which itself is divided into [frontend](https://github.com/SovereignCloudStack/status-page-web), [backend](https://github.com/sovereignCloudStack/status-page-api) as well as the [OpenAPI spec](https://github.com/SovereignCloudStack/status-page-openapi) and a [repository holding the deployment logic](https://github.com/SovereignCloudStack/status-page-deployment)) is de-coupled from the SCS Releases.

### [SCS is continuously built and tested](https://github.com/orgs/SovereignCloudStack/projects/6/views/21)

With [our zuul](https://zuul.scs.community) in place (thanks to the efforts throughout the R5 development cycle) it is now time to shift a lot of our test runs from GitHub actions to the zuul instance.
As part of the [tender VP01](https://scs.community/tenders/lot1) the test coverage of the foundations the IaaS reference implementation builds upon is continuously being extended.

### [SCS is opinionated](https://github.com/orgs/SovereignCloudStack/projects/6/views/29)

While the SCS projects provide a modular stack and strongly work towards interoperability, we want to be opinionated in our reference implementation. Being opinionated on that level leads to focus and avoids having too many loose ends. Good examples of this is how we address verticals such as our IAM or observability stacks.

### SCS charters new territory

While a lot of our activities involve working upstream with the various communities doing our part of ensuring the components that SCS is built upon are staying healthy, we do want to push the boundaries of what is possible further and see where we can find ways to provide better cloud infrastructure. This does mean to sail into unchartered waters - sometimes having to turn around, hit rock bottom or actually find a new cool passage.
Endeavors like the evaluation of [building community SONiC](https://github.com/SovereignCloudStack/issues/issues?q=is%3Aopen+is%3Aissue+label%3ASCS-VP04+sonic) images, revisiting the topic of cloud observability and testing and engaging into the discussion about the discoverability of flavors and functionality of OpenStack clouds.

