---
layout: post
title: "Journey Through Two Years of pluscloud open: A Recap of the SCS Stack Upgrade Path"
image: "blog/2023-scs-r4-pco-journey.png"
author:
  - "Ralf Heiringhoff"
  - "Toens Bueker"
  - "Markus Lindenblatt"
avatar:
  - "avatar-plusopen.png"
about:
  - "frosty-geek"
---

{% asset 'blog/2023-scs-r4-pco-journey.png' vips:format='.webp' style="width:100%; max-height: 450px; object-fit: cover;" %}

Over the past two years, [pluscloud open](https://www.plusserver.com/en/products/pluscloud-open) has made significant progress since its closed-beta launch in 2020. It is based on the SCS IaaS reference implementation developed by [OSISM GmbH](https://osism.tech), which stands on the shoulders of open source giants, including the [OpenStack Kolla Ansible](https://docs.openstack.org/kolla-ansible/latest/) framework.

The journey began with pluscloud open running on OpenStack [Ussuri](https://releases.openstack.org/ussuri/index.html) and has since been rolling upgraded following the SCS releases, currently running on the latest release of OpenStack, [Zed](https://releases.openstack.org/zed/index.html).

Before that we started with the Openstack [Stein](https://releases.openstack.org/stein/index.html) release by using the plain [kolla-ansible](https://docs.openstack.org/kolla-ansible/stein/) framework. After a lot of research we finally switched to OSISM's tools for deploying all components like openstack, ceph and preparing the infrastructure wth one central toolset.

For these upgrades, we follow a step-by-step approach through our dev and stage environments before upgrading production environments. This allows us to work through the release notes and detect unexpected issues. The upgrade process includes backups, operating system upgrades, functional and non-functional checks, updates of all OpenStack components on controllers, compute and manager nodes, as well as upgrades of our Ceph storage. This approach gives us the confidence to upgrade our production environments with zero or nearly no downtime.

In the beginning it was quite hard to get from the initial deployment to a running platform but with the time the documentation gets much better and more detailed and and there was a huge development in the toolset because a lot of people joined the SCS and began to contribute with opening issues and supporting with code.

Nowadays with the SCS R4 release we have high level of quality and the upgrading process has been developed in a way that is well structured and documented so that it is easy to get to the new version and the result is always the same even when having a timegap between dev and productive environments. That is realised by using fixed tagged container images.

Throughout this journey, we have been grateful to be part of an open and welcoming community around the Sovereign Cloud Stack. We take pride in having contributed to and supported this community.

{% asset 'blog/2023-scs-r4-pco-journey-sky-is-the-limit.jpg' vips:format='.webp' style="width:100%; max-height: 450px; object-fit: contain;" %}

pluscloud open has two productive public environments, prod1 and prod2, located in Cologne and Hamburg, respectively. prod1 went live in July 2021 with the SCS pre-R0 release, while prod2 was launched in March 2023, both running now the latest release SCS R4. It's important to stress that this achievement was made possible by the SCS community, which has kept up with the supported OpenStack releases and enabled us to perform rolling upgrades without major downtime.


As part of our commitment to building and improving a sustainable and data-sovereign Europe, we will continue to contribute to the Sovereign Cloud Stack Community. We aim to build a community of practice and transparency for operations using Open Operations, and we look forward to seeing what the future holds for the Sovereign Cloud Stack Community.

