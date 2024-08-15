---
layout: post
title:  "SCS Health Monitor released: What's inside and how to use it"
category: tech
author:
- "Piotr Bigos"
- "Katharina Trentau"
- "Tomáš Smädo"
- "Dominik Pataky"
avatar:
- "piobig2871.jpg"
- "default-avatar.jpg"
- "bitkeks.png"
about:
- "piobig2871"
- "bitkeks"
---

## Motivation and previous work

* Reference to the OpenStack health monitor as the initial testing tool for IaaS layer infrastructure, namely OpenStack
* StackMon (CloudMon) as an evaluated alternative framework for IaaS tests
* SCS health monitor should cover all SCS layers: IaaS, KaaS and tooling -> new proposal


## Concept

* Re-use the initial proposal
* Gherkin/Python, Behave/BehaveX
* API clients OpenStack and Kubernetes
* extendable to other tools as well (IAM, security, secrets, CI/CD, system monitoring)
* metrics push gateway, Prometheus, Grafana dashboard


## Implementation

* Rough guide through the code base in repo https://github.com/SovereignCloudStack/scs-health-monitor
* Steps that are taken, jump host etc.
* Clean up and tracking of resources


## Usage

* Setup requirements to run the tests (libraries, credentials)
* Running the tests on CLI
* What steps need to be taken to run the framework in a VM inside a CSPs infrastructure?
