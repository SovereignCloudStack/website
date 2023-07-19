---
layout: post
title:  "Revisited: Air gapped installation"
category: tech
author:
  - "Christian Berendt"
avatar:
  - "berendt.jpeg"
image: "blog/airgap-takeoff.jpg"
about:
  - "berendt"
---

A few months ago we wrote a concept for the implementation of
[air gapped installations](https://scs.community/de/tech/2023/04/12/airgapped-scs/)
from the infrastructure layer of Sovereign Cloud Stack (SCS). Sometimes
the opportunity arises to completely re-evaluate and re-analyze a concept
with some distance. If this possibility does not arise, it should be explicitly
planned and created.

One of the pillars of SCS is to pick up and use existing open source building
blocks. This is to avoid stretching the limited project budget unnecessarily
and to create a sustainable solution with broad acceptance. The available and
established solutions are not always a perfect match and you often have to adapt
to the realities. But even then, more complex own developments should be avoided
whenever possible. If existing technology does not match perfectly, you should
first try to adapt the problem in order to be able to use the existing technology
anyway. If this does not work, it should be examined whether existing technology
can be extended to make it suitable.

Back to the air gap installation. We had created a concept by providing a variety
of individual services, some of them own developments, to mirror the individual
sources like APT packages used within the infrastructure layer. After re-evaluating this
approach, we now have to note that something difficult to maintain has emerged.
We have asked ourselves who will finish the services and who will ensure that they
remain in good condition and usable for the next few years. In the end, we came to
the conclusion that it was not worth the time to continue with the previous concept.

So back to start? Not complete. The original idea of splitting the problem in two,
supplying the nodes of the control and data planes themselves, as well as supplying
the management planes and the hedging of our build processes were not discarded.
The approach with Squid as the middle layer between management plane and control and
data plane remains and is fully implemented. This ensures that all internal nodes are
supplied exclusively via the management plane.

On the management plane, all services planned in the
[original concept](https://scs.community/de/tech/2023/04/12/airgapped-scs/)
were discarded. [Pulp](https://pulpproject.org) now takes their place. Pulp is a
software repository management that can be extended with plugins.
[Pulp is established](https://analytics.pulpproject.org). Practically, all plugins
we need are already available and everything is controllable via API.

As a first step, a MVP of a Pulp service has now been built on the OSISM project
side and broadly populated with all Ubuntu and Ansible collections & roles.
Currently, the CI is being switched to pulp as the primary source. Packages of PyPi,
which are only required for the build of the OSISM container images, will be added
in this process.

Afterwards, a role `osism.services.pulp` will be provided with which the Pulp service
can be deployed on the management plane. The synchronization with the Pulp service
from the OSISM project will then be integrated into the OSISM CLI.

Completion: In time for the next major release of SCS.
