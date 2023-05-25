---
layout: post
title:  "Pedaling towards Release 5"
category: tech
author:
  - "Felix Kronlage-Dammers"
  - "Kurt Garloff"
avatar:
  - "fkr.jpg"
  - "kgarloff.jpg"
about:
  - "fkr"
  - "garloff"
---

## Pedaling towards Release 5 - an overview of our outcomes

To align the development efforts of our community we started thinking in *Outcomes* when looking at the development cycle.
This outlines our direction much better than talking about the next features that are planned and worked on.
SCS delivers building blocks for digital sovereign cloud infrastructure.  But we also change the way infrastructure is operated.

#### Working with outcomes on github

The outcomes allow us to view our development efforts through various angles. Throughout our github organization a specific label represents each outcome. The projects view has filtered views for each outcome to be able to quickly see which issues and working items play into which outcomes.

An [overall board](https://github.com/orgs/SovereignCloudStack/projects/6/views/28) summarizes all of them.

### [SCS is standardized](https://github.com/orgs/SovereignCloudStack/projects/6/views/23)

While the S in SCS (at least the first ;) stands for *Sovereign* it could also stand for *Standardized*.
SCS standardizes. Creating Standards within the community, reaching out to surrounding communities, working with upstream as well as other players in our ecosystem to make sure we don’t “just reinvent the wheel” or stew in their own juice is a fair share of our work within the project.

The [certification tender 10](https://scs.community/tenders/lot10) plays an important role in our ongoing standardization effort. Alongside the standardization work that happens in the container and IaaS teams this will lead to an increased pace on the standardization efforts through Release 5 cycle.

[Issue #285](https://github.com/SovereignCloudStack/standards/issues/285) gives an overview of standardization items for the IaaS layer.

The first results of our standardization effort became visible recently in our [standards repository](https://github.com/SovereignCloudStack/standards) where we now feature a 

### [SCS is understandable](https://github.com/orgs/SovereignCloudStack/projects/6/views/22)

In the last half year the [documentation page](https://docs.scs.community) came to life and thanks to the efforts of the SIG Documentation it is not just a pile of documents but has a concept to it. For SCS to be understandable more than just awesome docs are needed. Collecting feedback from SCS integrators just as much as people and organizations that have their first touchpoint with SCS plays an important role to assure SCS is continously becoming more understandable. 

### [SCS enables](https://github.com/orgs/SovereignCloudStack/projects/6/views/20)

For the R4 development cycle one of the outcomes we proclaimed was *SCS enables Operators with an excellent toolbox*. An excellent toolbox is part of what is needed for operating cloud infrastructure as a commodity. Looking at what we’ve done in the past eight months this outcome however is much too narrow. 
*SCS enables* - on a variety of levels and not just operators, but also integrators, developers and most important consumers of infrastructure built upon SCS who want to run on top of fully digital sovereign infrastructure.

### [SCS is transparent](https://github.com/orgs/SovereignCloudStack/projects/6/views/30)

Transparency is one of the core values embedded in our project - yet we want to make sure our development efforts throughout the R5 cycles are actively working towards being transparent. This ranges from our development culture (which needs to be transparent not only to be trustworthy but also to lower the barrier to join the community), to the open operations movement and all the way to technical items such as [SBOMs](https://en.wikipedia.org/wiki/Software_supply_chain) for our complete stack.
Transparent projects can be audited easily and thus trust can be built up more easily.

### [SCS is continuously built and tested](https://github.com/orgs/SovereignCloudStack/projects/6/views/21)

As part of the [tender 6d](https://scs.community/tenders/lot6d) the [work on our own Zuul instance](https://github.com/SovereignCloudStack/issues/issues/157) began in the R4 cycle. This will be the backbone of our own testing infrastructure - ranging from running CI for various components in the SCS stack up to end to end tests for the CAPI provider, an idea that was raised during the R4 retro.

### [SCS is opinionated](https://github.com/orgs/SovereignCloudStack/projects/6/views/29)

While the SCS projects provides a modular stack and strongly works towards interoperability, we are opinionated in our reference implementation. Being opinionated on that level leads to focus and avoids having too many loose ends. It forces us to take informed decisions. These decisions need to be well documented - which is why we started early in the R4 cycle to use our ADR framework. This in return pays into *SCS is understandable*. 
