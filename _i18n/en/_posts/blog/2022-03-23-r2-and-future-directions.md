---
layout: post
title:  "Future directions - the road towards R3"
category: foo
author:
  - "Felix Kronlage-Dammers"
avatar:
  - "/assets/images/fkr.jpg"
---

## Welcome Release 2

Today we're [releasing the R2](https://github.com/SovereignCloudStack/Docs/blob/main/Release-Notes/Release2.md) of the reference implementation of the Sovereign
Cloud Stack. Our release announcement covers the many aspects of this release
in detail. These range from our work on integrating the Kubernetes Cluster API,
many improvements that focus on the operator experience up to items that help
to assure standard conformance of clouds being built with SCS.

Since SCS has a fixed release schedule - we release twice a year - and through
all the lively discussions of the past weeks moving towards our R2 we already
have ideas of things we want to cover in the R3 cycle. 

## Reaching out to the community

SCS builds on top of the interaction of community members - CSPs, operators
of cloud infrastructure as well as integrators who either build or support the
process of building cloud infrastructure. 

There is a proposal for a [gitops style cluster management](https://github.com/SovereignCloudStack/Docs/pull/47)
approach on the table.

As part of our discussions in the last week around octavia we concluded that it
makes sense to further invest into the topic of loadbalancing withing cloud
infrastructure and see if the current status, not only concerning OpenStack, can 
be improved.

## Federation needs to happen

In R2 we started to lay the groundwork for the federation. Within the R3 cycle
we want to to document and validate (and probably enhance) the user federation
capabilities which we have implemented with [keycloak](https://www.keycloak.org) and OpenID Connect federation.

## Help to increase velocity...

One of the goals of SCS is to help operators gain more velocity with their
cloud infrastructure. However this relies on intensive testing and excellent
quality assurance. As part of this effort we have started to use [zuul](https://zuul-ci.org) as CI
framework and intend to make significant progress in connecting all the
existing tests to it.

## ...as well as standard compliance and observability

Good and extensive testing, while being important, are not the only aspects
of providing solid cloud infrastructure. We want to heavily invest in SCS
conformance testing, allowing providers that differ significantly from our
reference implementation to still adjust their platforms for full
compatibility. With the work that is happening in the Special Interest
Group (SIG) Monitoring we want to make sure operators have an in-depth
view into their stack. This will range from reworking the [OpenStack
Health Monitor](https://github.com/SovereignCloudStack/openstack-health-monitor) to build upon existing components such as [tempest](https://opendev.org/openstack/tempest/) and
[rally](https://opendev.org/openstack/rally) as well as making sure logs are aggregated and can be analyzed.

## Metering and Billing

In the last months metering and billing were discussed within our community.
It has become apparent that this is one of the topics where the SCS project can
provide added value to the broader OpenStack community and this will be one of
the items that will be followed upon in the next few months.

## Encrypt all the things

The scs community started to work on a disk encryption feature based on [tang](https://github.com/latchset/tang). We've
seen first previews of it and a lightning talk covered this first preview. For R3
we intend to complete the disk encryption feature.

## Join the discussion

As with the last release we will dive into a short retrospective mode in the upcoming
week. In our team sessions in the calendar week 13 we will focus on reviewing our
collaboration of the last months and see what can be kept, improved, started or stopped. 
While there are ideas out on what R3 should bring our community is invited to join the
discussion and help to shape SCS so that it adds value to your cloud infrastructure.
The team meetings in week 14 are dedicated to these topics.

We invite our community to join the discussions in the corresponding team sessions.

