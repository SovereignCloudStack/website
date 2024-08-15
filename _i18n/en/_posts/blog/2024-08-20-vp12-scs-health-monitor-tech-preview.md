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
* metrics [push gateway](https://prometheus.io/docs/practices/pushing/), [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/) dashboard


## Overview
This framework is designed to facilitate Behavior-Driven Development (BDD) for testing Kubernetes deployments using the behave Python library. The framework allows you to write human-readable tests that validate Kubernetes clusters, pods, services, and other resources. Installation Prerequisites

Before you begin, ensure you have the following installed on your machine:

Python 3.8+ pip (Python package installer) kubectl (Kubernetes command-line tool) Helm (Kubernetes package manager)

## Implementation

* Rough guide through the code base in repo https://github.com/SovereignCloudStack/scs-health-monitor
* Steps that are taken includes: 
    - resource creation
    - building test infrastructure
    - tests
    - cleanup the created resources


## Usage

1. Clone the Repository:
``` bash
git clone https://github.com/SovereignCloudStack/scs-health-monitor
cd scs-health-monitor
```
2. Set Up a Virtual Environment:

It's recommended to use a virtual environment to avoid conflicts with other Python packages.

python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

3. Install Required Python Packages:

Install all necessary Python packages using pip.

```bash
pip install -r requirements.txt
```

4. Install Additional Tools (Optional) or run script install_env.py:

If you need to install and manage an NGINX Ingress controller, you'll need helm.

For MacOS:
```bash
brew install helm
```

For Linux:
```bash 
sudo apt-get install helm
```

In this repository (under main directory) you have to create two files that will be referenced by `env.yaml` and `clouds.yaml`
* env.yaml:
```
   OS_AUTH_TYPE: ""
   OS_AUTH_URL: ""
   OS_IDENTITY_API_VERSION: ""
   OS_REGION_NAME: ""
   OS_INTERFACE: ""
   OS_APPLICATION_CREDENTIAL_ID: ""
   OS_APPLICATION_CREDENTIAL_SECRET: ""
   OS_PROJECT_NAME: ""
   OS_USER_DOMAIN_NAME: ""
   OS_PROJECT_DOMAIN_NAME: "" 

   ```
* clouds.yaml:
```
clouds:
  gx:
    region_name:
    auth_type:
    auth_url:
    identity_api_version:
    interface:
    application_credential_id:
    application_credential_secret:
```

## Running the Tests

You can run the tests using the behave command from the root of your project:

```bash
behave
```

This will execute all the scenarios defined in the .feature files within the features directory.

### Example Command to Run a Specific Feature File

To run a specific feature file, use:
```bash
behave container_level_testing/features/container_creation.feature
```

### Adding New Features
Creating New Step Definitions

To add new behavior or extend existing features, define new steps in the Python files located in container_level_testing/features/steps/. These files map Gherkin steps to Python code.

```python
@given('describe what test is doing')
def name_of_the_test(context):
    ## Body of the test 
```

#### Creating New Feature Files

1. Create a New Feature File:

Add a new .feature file in the features directory.

2. Write Scenarios in Gherkin Syntax:

Define the behavior you want to test using Given-When-Then steps.
```gherkin
Feature: New Kubernetes Feature

  Scenario: A new feature scenario
    Given name of the function 
    When name of another function with logic
    Then step with assertion to verify if step before was succeded 
```

3. Implement the Step Definitions:

Add the corresponding step definitions in the appropriate .py file under features/steps/.

* What steps need to be taken to run the framework in a VM inside a CSPs infrastructure?
