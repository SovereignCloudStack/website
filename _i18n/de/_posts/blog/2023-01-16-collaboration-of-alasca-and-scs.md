---
layout: post
title: "Collaboration of ALASCA and SCS"
author:
  - "Kurt Garloff"
  - "Marius Feldmann"
avatar:
  - "kgarloff.jpg"
  - "mfeldmann.jpg"
image: "blog/fistbump.jpg"
---

The Sovereign Cloud Stack (SCS) project is a platform for open collaboration
where a provider-focused ecosystem collaborates to create and operate cloud and
container technology together in order to support their customers to achieve
higher levels of Digital Sovereignty. Common certifiable standards, a fully
open modular reference implementation and transparency and knowledge sharing
for operational processes are main outcomes from this collaboration. SCS is
hosted by the OSB Alliance e.V. and funded by the BMWK (German Ministry for
Economic Affairs and Climate Action).

While the reference implementation of course instantiates and also inspires the
standards, these can be implemented independently by other open (or even
non-open) implementations. This way preexisting environments can become fully
SCS-compatible platforms. On the other hand, new technology can be integrated,
resulting in more modern fully-compliant implementations before possibly
becoming mainstream at a later point in time. This can happen at all layers and
all components of the stack. Obviously, the stronger the divergence, the
smaller the benefits for the operators from the joint creation of technology
and operational practices, but the tradeoffs can vary for different operators.

Cloud&Heat Technologies has been supporting and contributing to Sovereign Cloud
Stack since a long time. Cloud&Heat has also joined the OSB Alliance to
strengthen its support for Open Source. Cloud&Heat and Sovereign Cloud Stack
also have been working together in various Gaia-X groups and proposals for the
upcoming IPCEI-CIS. A particular joint activity by the authors in this overall
context was a talk provided at the  Open Infrastructure Summit in 2020 stating
a common motivation for open infrastructure in general and a project such as
the SCS specifically (see recording[^OpenInfra]).

While the stacks built and operated by Cloud&Heat do diverge in several details
from the SCS reference implementation, joint technology is being developed and,
more importantly, standardization happens together, with the goal to have fully
SCS-compliant stacks also built by Cloud&Heat with some distinct implementation
choices.

Cloud&Heat has been developing yaook, a modern Kubernetes based life-cycle
management solution for OpenStack together with STACKIT and other partners from
the ALASCA association. After open-sourcing it, giving it a home for further
development with a good open governance model is an important motivation to set
up a lean non-profit organization that can focus on pushing forward the yaook
development and perspectively development of further related projects.

This move creates extended opportunities for yaook to grow and opens a way for
intensified and structured collaboration between SCS and the broader set of
yaook partners around ALASCA. We will continue to work on joint technology and
speed up the standardization efforts. As soon as we have achieved a solid
state, we want to create SCS reference blueprints that leverage yaook
technology, showcasing that indeed the SCS standards can be implemented in more
than one way.

[^OpenInfra]: <https://www.openstack.org/videos/summits/virtual/Digital-Sovereignty-Why-Open-Infrastructure-Matters>
