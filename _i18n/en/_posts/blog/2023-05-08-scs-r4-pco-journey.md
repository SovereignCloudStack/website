---
layout: post
title: "Journey Through Two Years of pluscloud open: A Recap of the SCS Stack Upgrade Path"
image: "blog/2023-scs-r4-pco-journey.png"
author:
  - "Ralf Heiringhoff"
  - "Toens Bueker"
  - "Markus Lindenblatt"
avatar:
  - "avatar-pluscloudopen.png"
about:
  - "frosty-geek"
---

{% asset 'blog/2023-scs-r4-pco-journey.png' vips:format='.webp' style="width:100%; max-height: 450px; object-fit: cover;" %}

Over the past two years, [pluscloud open](https://www.plusserver.com/en/products/pluscloud-open) has made significant progress since its closed-beta launch in 2020. It is based on the SCS IaaS reference implementation developed by [OSISM GmbH](https://osism.tech), which stands on the shoulders of open source giants, including the [OpenStack Kolla Ansible](https://docs.openstack.org/kolla-ansible/latest/) framework.

The journey began with pluscloud open running on OpenStack [Ussuri](https://releases.openstack.org/ussuri/index.html) and has since been rolling upgraded following the SCS releases, currently running on the latest release of OpenStack, [Zed](https://releases.openstack.org/zed/index.html).

Before that, we started with the OpenStack [Stein](https://releases.openstack.org/stein/index.html) release using the plain [kolla-ansible](https://docs.openstack.org/kolla-ansible/stein/) framework. After extensive research, we switched to OSISM's tools for deploying components like OpenStack and Ceph, and preparing the infrastructure with a central toolset.

For upgrades, we follow a step-by-step approach through dev and stage environments before upgrading production environments. This allows us to work through release notes and detect unexpected issues. The upgrade process includes backups, OS upgrades, functional and non-functional checks, updates of all OpenStack components on controllers, compute and manager nodes, as well as upgrades of our Ceph storage. This approach gives us confidence to upgrade our production environments with little or no downtime.

Initially, getting from the initial deployment to a running platform was challenging. However, with time, documentation improved significantly, and there was a significant development in the toolset due to community contributions in opening issues and supporting with code. Nowadays, with the SCS R4 release, the upgrading process is well-structured, documented, and easy to follow, resulting in the same output even when there is a time gap between dev and productive environments. This is achieved by using fixed tagged container images.

During this journey, we are proud to have been part of an open and inclusive community around the Sovereign Cloud Stack. We take great pride in the contributions we have made and the support we have provided to this community. We are particularly proud of our involvement in the [Open Operations](https://openoperations.org/) movement and are committed to building a community of practice and transparency for operations using this framework. Moving forward, we are excited to see what the future holds for the Sovereign Cloud Stack Community and are committed to continuing our contributions to building a sustainable and data-sovereign Europe.

{% asset 'blog/2023-scs-r4-pco-journey-sky-is-the-limit.jpg' vips:format='.webp' style="width:100%; max-height: 450px; object-fit: contain;" %}

pluscloud open has two productive public environments, prod1 and prod2, located in Cologne and Hamburg, respectively. prod1 went live in July 2021 with the SCS pre-R0 release, while prod2 was launched in March 2023, both running now the latest release SCS R4. It's important to stress that this achievement was made possible by the SCS community, which has kept up with the supported OpenStack releases and enabled us to perform rolling upgrades without major downtime.

