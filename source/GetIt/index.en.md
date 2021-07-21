# Get Sovereign Cloud Stack

## Getting SCS

Sovereign Cloud Stack is fully Open Source -- we develop it in an open
development process in an open community. We follow the
[Four Opens](https://openinfra.dev/four-opens/) of the Open Infrastructure
Community. We work closely with the upstream projects from the
[Open Infrastructure Foundation](https://openinfra.dev/), the
[Cloud Native Compute Foundation](https://cncf.io/) and other open
source communities. Most of our source code comes from these
communities -- when we improve, amend, change things, we seek the
contact with these communities to contribute our changes back.

We use [github](https://github.com/SovereignCloudStack/) to
manage the code we are using -- our own code mainly
consists of the automation and integration that glues the used
upstream projects together in a consistent and manageable way.
Add documentation and CI tests to the mix.

To install your own SCS code, so you can study, test, change it
and contribute to it, we refer you to our
[github Docs](https://github.com/SovereignCloudStack/Docs/)
repository.

On Jul 15, 2021 we have published [Release 0](/News/release0.html.en).

## SCS and OSISM

For the base layers, we heavily build on top of the
[Open Source Infrastructure and Service Manager](https://osism.tech/) (OSISM)
project.

## Contributing

We have created a 
[contributor guide](https://scs.community/docs/contributor/)
that documents some of policies and processes we have
chosen.

If you want join the effort, we encourage you to
[get in touch](mailto:project@scs.sovereignit.de) with us.
We will do a short onboarding session and invite you to weekly
virtual team meetings.

We also appreciate occasional feedback from people -- feel
free to raise issues on github or better open PRs. Don't forget
to use DCO (Sign-off) to ensure we can use your contribution in
a legally safe way.

## Adopting SCS

There are different steps you can take to support and adopt SCS.

First of all, we appreciate contributions to SCS and to the relevant
upstream open source projects. If we can join forces upstream to
successfully push topics that are relevant e.g. for digital sovereignty,
that's great.

If you consider adopting SCS, there are two dimensions: Which modules
and what adoption level.

First is that SCS is modular. You might adopt just some pieces of
our container stack. Or maybe the Ops stack. Or IaaS. Or ceph.
Or maybe everything but ceph ...

On the adoption level there are two possibilities:

First level would be that you want to make your platform compliant with SCS
standards for this module. This ensures you are compatible to a growing
ecosystem.  This requires to pass conformance tests. (Note that as of July
2021, most of the conformance tests are still to be developed, but they will
come as they are an integral part of our deliverables.)

Second level would be using the (reference) implementation for the module
in question. This means you are using and contributing to the same piece
of code and save a lot of work in curating, integrating, automating,
testing, documenting this piece. Importantly, as we create best practices
for Operations, you'd also be able to participate in this -- possibly
opening yourself up to a model, where you could share Operational
duties in an OpenOps model.

So an adoption matrix could look like this (simplified):

| Module       | Adoption level 2021 | Adoption level 2022 |
|--------------|:-------------------:|:-------------------:|
| Monitoring   |     none            |  compliant          |
| IaaS         |     compliant       |  implementation     |
| Storage      |     none            |  none               |
| k8s-capi     |     implementation  |  implementation     |
| k8s registry |     implementation  |  implementation     |

