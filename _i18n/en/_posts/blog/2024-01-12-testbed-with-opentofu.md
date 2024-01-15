
[OSISM](https://osism.github.io/) is known as the reference implementation for the Infrastructure-as-a-Service layer in the Sovereign Cloud Stack (SCS) project.
The [OSISM testbed](https://github.com/osism/testbed) is therefore used in the SCS project to demonstrate, test and further develop the Infrastructure-as-a-Service layer.

The development of OSISM and SCS presents a number of challenges due to the distributed nature of the system architecture,
which can extend to different levels. In addition to the purely functional testing of infrastructure components, as is possible with
[Cloud in a box](https://docs.scs.community/docs/iaas/guides/deploy-guide/examples/cloud-in-a-box) (each component exists exactly once), it is therefore also very useful to test the various components in a scenario.
components in a scenario that is more similar to a productive setup by operating the various components in a cluster mode.
operated in a cluster mode. In this way, some [non-functional](https://en.wikipedia.org/wiki/Non-functional_requirement) configuration and implementation issues can also be
implementation issues can be simulated, developed and verified in the testbed.

Virtual machines, network and storage based on OpenStack are used as the basis or to provide the testbed.
As SCS also virtualizes systems itself, the OpenStack environment must provide the capabilities for nested virtualization.

The SCS testbed previously used Terraform to automatically set up and manage the basis for the required infrastructure components.
Terraform was previously published under the Mozilla Public License v2.0 and was therefore a good fit for OSIS in terms of its terms of use and openness.
and its openness to the OSISM and SCS project.

With the announcement of August 10, 2023, Hashicorp has announced that this will change in the future - future
versions will be made available under the Business Source License v1.1, at least in relevant parts.
As we have a very strong interest in ensuring that our project is based on serious open source components,
it was foreseeable that we would have to find a sensible alternative that meets our requirements.

Fortunately, on September 2, 2023, a Terraform fork was founded under the umbrella of the Linux Foundation under the
of the Linux Foundation under the terms of the Mozilla Public License 2.
With the first official and stable release of [OpenTofu](https://opentofu.org/), OSISM and SCS are now presenting their Infrastructure-as-Code
realization in the testbed to OpenTofu version 1.6.0.

The migration was very simple: from our point of view, OpenTofu can be described as a drop-in replacement for Terraform with a clear conscience.

With today's integrated code version, we have made some detailed improvements to the installation of the i
dependencies and the [documentation](https://docs.osism.tech/testbed/) of the testbed.
It is now only necessary to install `make`, `wireguard` and `python-virtualenv` on the testbed user's computer.
All other dependencies such as OpenTofu and Ansible are now installed or managed according to the status of the Git-BRanch.
In this way, we ensure that testbed users will have less effort in the future when managing the tools and
ensure that the testbed is used with the right tools in the right versions.

Finally, I would like to reiterate my enthusiasm for open source in connection with Terraform.
The openness of Terraform to date and the commitment of the community have ensured that we can switch to an alternative and future-proof testbed with little effort.
migrate to an alternative and future-proof product with little effort.

