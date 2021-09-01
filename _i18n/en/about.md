# About Sovereign Cloud Stack

Sovereign Cloud Stack (SCS) is a network of existing and future providers
of standardized sovereign cloud and container infrastructure to join
forces in defining, implementing and operating a fully open, federated,
compatible platform. By joining forces, the platform can support
a healthy ecosystem for service and application developers and strengthen
the digitalization efforts in Europe without creating large risks to
lose control over the technology and the data.

## Goals

### Certifiable Standards

We aim to define well-defined standards, that are precise enough so that
software implemented and tested on one SCS implementation will work without
additional effort on other SCS based infrastructure. The standards are
a collection of upstream standards enhanced with specific choices that
are not specified upstream. We are working on providing conformance tests
so that changes can be validated w.r.t. their impact on compliance.

Certifiable standards are the prerequisite to create a vivid ecosystem
on top of SCS.

We also work on (optional) standards with operational topics; transparency
with respect to monitoring and root cause analyses in case of issues are
immediate customer benefits; for operators, it helps to share knowledge
on the Ops piece of DevOps for efficiency and for helping with recruiting
staff.

Quality and Security tests are also part of the testing, so conformance with
e.g. security standards can also be continuously assured.

### Openness and Transparency

All software is fully open source -- we don't believe in open core models.
It's not just the software license: The software is developed in an
open development process with open design discussions and decisions by
an open community. This ensures that the software really can be used
and influenced by the recipients, thus ensuring the freedom of its consumers.

The transparency of the code and the development process is an important
ingredient to ensure that the code can be trusted.

### Sustainability

The IT world is fast-paced. New technologies replace older ones very quickly.
With Sovereign Cloud Stack, we aim to have fairly stable software infrastructure
at the base layer, while accommodating rapid change at higher layers.
Having a fairly sustainable base layer in place avoids the need for
operators to constantly rebuild the base layers.

This also creates the space to work on sustainability with respect to
energy consumption: Automating energy-aware placement decisions and using
power saving technologies are important topics in SCS.

### Federation

Our vision replaces centralized infrastructure control with a network
of providers that collaborate. The highly compatible SCS clouds, good
network connections plus federable identity and access management
brings us a significant step closer to create a large global
virtual cloud without a central controlling entity.

## Advantages ...

### ... for DevOps teams (developing PaaS/SaaS)

Having a well-defined environment that can be operated as small
private cloud or as large public clouds alike avoids duplicated
implementation and validation work. Targeting SCS is thus rather
efficient.

### ... for Public Cloud Operators

Adhering to SCS standards and being part of the SCS ecosystem creates
a much larger set of applications DevOps teams and applications that
work on the cloud. The addressable market thus grows significantly.

Moving from only adhering to standards towards using some or all of
the SCS modules from the reference implementation also saves a lot
of duplicated work in curating, configuring,
integrating, automating, testing, documenting the software and
building up the operational processes, monitoring, updating, ...
for running it.

Last not least, the operational work can more easily be shared with
others or even outsourced. And skilled staff is more likely to
be available.

### ... for the society

Using modern IT infrastructure with full automation for
infrastructure deployment and life cycle management
(= Infrastructure as Code) provides a huge boost to the
productivity of software DevOps teams. Europe urgently needs
this boost to avoid falling (further) behind in the global
competition, where more and more traditional industries are
disrupted by digital innovation.

Unfortunately, just relying on the hyperscalers comes with
many disadvantages:

* It does not always fit the use scenario where you might
  need decentralized IT infrastructure (edge).

* It creates legal challenges with respect to data privacy
  (and sometimes also security) compliance.

* It creates a strategic dependency on one or a small
  set of very large companies.

* It creates economic dependencies.

All of these are inhibitors to adopting hyperscaler clouds.

Having the choice to use local SCS cloud providers or even creating
and operating your own SCS cloud gives you the advantages of modern
IaC infrastructure without these downsides.

From a geopolitical angle, ensuring that a growing part of the
value creation of the increasingly digital value chains can remain
in Europe is reducing the strategic risks and is increasing the captured
value.

## Deployment models

Standard SCS is optimized for small (half a rack) to large (hundreds
of servers per region) clouds in the data center or the near edge.

The deployment can be done as a private cloud by a skilled IT
department or as a public cloud by a CSP. We have both in our network.

We are working on planning optimized far-edge scenarios in a
followup project ("SCS-2").

## Sovereign Cloud Stack and Gaia-X

Digital sovereignty is a key goal of [Gaia-X](https://gaia-x.eu/).
We believe that many scenarios that require sovereignty at the
data level can not be achieved well without control over the
infrastructure.

SCS thus intends to make it a lot easier to provide sovereign
infrastructure. As such it has been included in the Gaia-X effort.
Historically, it was a sub working group in the software and
architecture working group in workstream 2 -- it is today an (Open) Work
Package connected to the Provider Working Group of the Technical
Committee of the Gaia-X AISBL.

SCS members support many efforts in Gaia-X, such as the
Federation Services / Open Source Software Working Group,
the Infrastructure sub working group, the Architecture of
Standards work package, the product and service board, the
minimal viable gaia piloting group, the self-descriptions
work package and the cross-environment service orchestration group.

There is a close link with the Gaia-X Federation Services
([gxfs](https://gxfs.de/)) effort. There is a shared vision of
providing SCS with GXFS on top as a platform for sovereign data
services. SCS partners support GXFS with infrastructure to validate
the gxfs implementation.

## Project and funding

The SCS project was initiated by volunteers. With the funding,
the project is now hosted by the [OSB alliance](https://osb-alliance.de/)
which has hired a small central team to drive and coordinate the
projects.

There is a growing community of volunteers around the central team
that contributes to the SCS project.

With the funding in place, FOSS development that does not necessarily
benefit individual companies enough can also be funded. The work packages /
lots for this go through an open tender process.

## Technological Vision

Automating the life cycle management of all components is key: Basic
infrastructure services such as the database, message queue, ..., the
operational stack (monitoring, patching, logging, metering, ...),
the identity management stack (LDAP, keycloak, ...),
the base virtualization layer (KVM, ceph, OVN), the VM layer
(OpenStack core services) and the Kubernetes tooling are all covered
by this. We use a containerized deployment driven by Ansible.
The containers at the base layer however are managed using classical
Docker/Podman -- we explicitly control placement etc. here and do
not see the highly dynamic capabilities of Kubernetes at this layer
as an advantage. This is of course different in higher layers that
change much more often depending on the customer needs.

<figure class="figure mx-auto d-block" style="width:90%">
  <a href="{{ "/assets/images/201001-SCS-4a.png" | prepend: site.baseurl_root }}">
    <img src="{{ "/assets/images/201001-SCS-4a.png" | prepend: site.baseurl_root }}" class="figure-img w-100">
  </a>
  <figcaption class="figure-caption">
    The figure shows the architectural structure and components of SCS.
  </figcaption>
</figure>

The core OpenStack services are mainly used to be a strong multitenant
foundation for managing many k8s clusters -- the real service here
is k8s aaS -- we are offering the k8s cluster API as interface to
manage k8s clusters; providers can of course use it internally as
well to create managed services. Exposing the OpenStack layer is
optional from an SCS standardization point of view. If it is exposed,
we however have standards to cover it, so we can deliver compatibility
at this layer as well.

<figure class="figure mx-auto d-block" style="width:90%">
  <a href="{{ "/assets/images/Ecosys-SCS-Acatech.png" | prepend: site.baseurl_root }}">
    <img src="{{ "/assets/images/Ecosys-SCS-Acatech.png" | prepend: site.baseurl_root }}" class="figure-img w-100">
  </a>
  <figcaption class="figure-caption">
    The above figure shows an ecosystem with four clouds, two of them using
    SCS standards. The container layer can be managed across both of them.
    For cross-cloud container management across other technologies,
    software like Gardener can be used – we do validate that it functions
    well on SCS. The picture has been created while working with 
    <a href="https://www.acatech.de/">Acatech</a> on the
    <a href="https://www.acatech.de/publikation/digitale-souveraenitaet-status-quo-und-handlungsfelder/">whitepaper on digital sovereignty</a>.
    The first edition contains an older version of the picture though.
  </figcaption>
</figure>

Note that the technology choices that are not
part of the mandatory standard (S) may not necessarily be final.
The SCS Platform Services are not part of the base SCS project ("SCS-1");
however we have plans prepared to extend SCS into this
space "SCS-3".

## Use SCS and join us

See the page [Use SCS]({{ site.baseurl }}/use/).
