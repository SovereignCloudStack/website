---
layout: post
title: "Costs of making an OpenStack cluster SCS-compliant"
author:
  - "Hannes Baum"
  - "Martin Morgenstern"
---

TODO(martinmo): introduction needs work – more "catchy"

For our work in the SCS standards repository and the SCS teams requiring standardized documents, we wanted to test out
the process of making an OpenStack cluster SCS-compliant. This would also give us insight about the costs of adopting
SCS standards, in terms of both time and money. This blog post provides the results of our findings
and shows the process we went through.

TODO(martinmo): write a small outline

## Where we started from

Our focus in this evaluation was on OpenStack clusters and therefore the IaaS standards, simply because IaaS already provided
a reference "SCS Compatible IaaS" at the time we started (in the future, a similar evaluation and blog post for the KaaS layer
is planned).

For the purpose of our evaluation, we set up two OpenStack clusters with [Yaook](https://docs.yaook.cloud/concepts/overview.html)
("Yet Another OpenStack On Kubernetes"): a virtualized test setup in our OpenStack cloud – i.e., OpenStack in OpenStack – and a
bare-metal production setup.

Yaook is a lifecycle management tool for OpenStack which leverages a Kubernetes cluster (provided by
[Yaook K8s](https://yaook.gitlab.io/k8s/)) to deploy and manage OpenStack components by means of the
[Yaook Operator](https://docs.yaook.cloud/handbook/user-guide.html#introduction-to-yaook-operator).
At the time of writing, a vanilla Yaook deployment is not SCS compliant and, as such, it is the ideal playground for our evaluation.
Even better: the lessons we learned while adopting IaaS standards in these deployments can be easily transferred to other OpenStack
deployments which do not use Yaook.
This test setup is represented in the following visualization:

TODO(cah-hbaum): insert graphics

The virtualized test setup was tricky to handle, which is not surprising, after all it is a nested OpenStack deployment.
The standards required by the SCS could still be applied to this setup, but not all of them could be tested with
the available test scripts.

For the bare-metal production deployment we used [Yaook Bare Metal](https://gitlab.com/yaook/metal-controller) to deploy and
manage server hardware, including rollout and configuration of operating systems, networks and disks.
This setup helped us identify additional problems with our configuration in general and allowed us to test applying
the standards on a setup without an additional layer of virtualization.
In the end, this setup was moved to another physical location and will provide the first SCS-compliant cluster of
Cloud&Heat Technologies GmbH built with Yaook.

In retrospective, using Yaook for this kind of deployment allowed us to quickly set up an OpenStack cluster and
focus on the adoption of SCS standards in this cluster.

## Required standards

TODO: explain scopes

As it was already explained above, the main effort leading to this post was focused on the IaaS standards, mainly because
it was clearer which standards needed to be applied from the *SCS Compatible IaaS* scope (we switched from v3 to v4 during this
work since the versions changed midway through). While it is true that all *stable* standards theoretically
need to be complied to, some of them don't have tests yet and/or are not featured in the "Compatible" label,
and are therefore not checked yet.

The standards relevant for IaaS, and therefore our OpenStack deployment, can be found under the numbers "SCS-0100-vX" and
counting in the [Standards repository](https://github.com/SovereignCloudStack/standards).
Higher versions take precedence, except if the newest version is still in the "Draft" state.
Looking through the repository as well as the ["SCS Compatible IaaS"](https://github.com/SovereignCloudStack/standards/blob/main/Tests/scs-compatible-iaas.yaml) document provides the relevant documents
and information required to make a cluster compliant.

At the moment of writing this blog post, the following standards are required, if an OpenStack instance should be SCS-compliant:

* [SCS-0100-v3](https://docs.scs.community/standards/scs-0100-v3-flavor-naming) *Flavor Naming* Standard
* [SCS-0101-v1](https://docs.scs.community/standards/scs-0101-v1-entropy) *Entropy* Standard
* [SCS-0102-v1](https://docs.scs.community/standards/scs-0102-v1-image-metadata) *Image Metadata* Standard
* [SCS-0103-v1](https://docs.scs.community/standards/scs-0103-v1-standard-flavors) *Standard Flavors and Properties* Standard
* [SCS-0104-v1](https://docs.scs.community/standards/scs-0104-v1-standard-images) *Standard Images* Standard
* [SCS-0110-v1](https://docs.scs.community/standards/scs-0110-v1-ssd-flavors) *SSD Flavors* Decision Record (enhances SCS-100-v3)

## Achieving compliance

After figuring out the relevant standard documents, the information required to achieve compliance needed to be extracted.
The focus here was on analyzing the document for the keywords mentioned in [SCS-0001-v1 Sovereign Cloud Standards](https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0001-v1-sovereign-cloud-standards.md).
This provided all expected values, configurations and pre-configurable setups relevant for the OpenStack cluster.

Another source besides the standard documents were the tests provided for them. For example, "SCS-0104-v1 Standard Images"
doesn't provide a set of standard images, since they could change over time due to new requirements and the SCS didn't
want to change their standard document every time. Instead, the test provides a YAML file with the required images as well
as additional meta information; the exact schema of this file is defined in the standard.

Without going too much in-depth (since most of this can be found in the standards themselves), the following points need
to be achieved in order to provide an SCS-compliant OpenStack cluster:

* Flavors must follow a naming schema defined by "SCS-0100-v3 Flavor Naming" if they start with `SCS-`. This naming schema
  also requires the underlying assignments (like core count, RAM, etc.) to be aligned with it.
* VMs must provide enough entropy for cryptographic operations.
* Images should be labeled with plain `Distribution Version` names and provide relevant metadata, so called `properties`.
  These `properties` are defined by "SCS-0102-v1 Image metadata", some of which are also mandatory.
* SCS-0103-v1 defines a list of mandatory and recommended flavors, which also follow the flavor naming scheme.
  It requires additional properties, so-called `extra specs` to be defined in order to indicate an SCS flavor.
  SCS-0110-v1 adds to this, since it requires two additional flavors with local SSDs or NVMEs as mandatory flavors.
* SCS-0104-v1 defines a YAML file containing a list of mandatory and recommended images as well as metadata like their sources.

Luckily, most of these standards could (in our case) be easily adopted with the help of the [osism-flavor-manager](https://github.com/osism/openstack-flavor-manager) and the
[osism-image-manager](https://github.com/osism/openstack-image-manager), which both offer options to create SCS-compliant flavors and images with the correct names
and relevant meta information. *osism-flavor-manager* can do this fully automatic, whereas the *osism-image-manager* requires
a file containing the necessary information; this is nonetheless easier than doing this work manually, since only one
file needs to be maintained and up-to-date with the standards.

Making all flavors compliant requires a bit more work if not all of the compute hosts have local SSD storage.
Local SSD storage is required by the two mandatory flavors `SCS-4V-16-100s` and `SCS-2V-4-20s`.
If this is the case, one needs to group the compute hosts with SSDs into an aggregate, mark that aggregate with a corresponding property,
and bind the two SSD flavors to this aggregate via `aggregate_instance_extra_specs`.
Without this additional configuration, workload might be scheduled to non-SSD-capable hosts.
More information about this can be found in the [OpenStack docs](https://docs.openstack.org/nova/latest/admin/aggregates.html#example-specify-compute-hosts-with-ssds).

TODO(martinmo/cah-hbaum): include specific steps (e.g. running osism-image-manager)

Lastly, the entropy standard shouldn't require too much work, since modern Linux kernels (which are used by the
standard images mentioned in SCS-0104-v1) provide enough entropy even in a VM. Additionally, CPUs must provide specific
CPU instructions if not enough entropy is available, which shouldn't be filtered by the hypervisor.
The only part maybe requiring additional work is setting the attribute `hw_rng_model`, which isn't mandatory.

## But at what cost?

A relevant question we had with this was the cost of adopting all these standards for an OpenStack cluster.
Based on the work time after the cluster setup and without debugging, since this part would be minimized on a second
or third attempt at this, we estimated around 4-6 man-hours for a minimal, freshly installed cluster. Doing this multiple
times could reduce this time even further so something like 1-3 man-hours.

Now it is important to mention, that we had nearly ideal circumstances, since there was neither hardware missing nor
the additional costs associated with adopting an older cluster which already contained data.
If an older cluster needs to be adopted to the standards, it would be necessary to add metadata to existing images, possibly
change their names and (if desired) change flavor names to the SCS naming schema. This would require significantly more time
to do; we estimate this with around 0.2-1 man-hours per image or flavor. If this needed to be done more often or multiple
times, some form of automation would be recommended, but this would also incur some upfront man-hour cost.
Additional costs could come up if no SSDs were provided for the cluster. This would require a hardware upgrade, incurring
cost for hardware (120-200€ per Terabyte), server downtime as well as man-hours. The actual costs here are hard to estimate
and would probably change from case to case.

Nonetheless, it is to mention that in most cases, SCS-compliance should be easily achievable for most OpenStack clusters
without having too much overhead in adoption costs. This could obviously change in the future with the arrival of
additional standards.

TODO(martinmo): conclusion/summary and outlook (e.g., KaaS layer)
