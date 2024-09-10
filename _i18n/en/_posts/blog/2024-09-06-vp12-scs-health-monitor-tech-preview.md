---
layout: post
title:  "SCS Health Monitor Tech Preview: What's inside and how to use it"
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
- "fraugabel"
---


Coming closer to SCS release R7, more and more projects are finalized and ready to be tested by a broader audience. This also includes the newly developed SCS Health Monitor (SCSHM), which we present to you in this blog post!

## Motivation

To start, what exactly do we mean by "health monitoring"? Aren't metrics, monitoring dashboards and alerts good indicators of healthy platforms? – While this might be enough in general, SCS also takes another aspect of "health" into account: actively testing behaviour of the platform.

This means automated systems execute predefined actions, using the same credentials and privileges as users would, against SCS-based systems. Running these scenario tests covers many paths and workflows end-customers or operators would also take in their daily doing, so that tests are very much aligned with real-world use cases. Errors in the platform can be caught early on. Some might know this pattern as "Behavior Driven Development" (BDD), BDD testing or Behavior Driven Monitoring.

## Previous work

Even though we are talking about a "tech preview", the concept for BDD testing in SCS is not new. For some time now, the [OpenStack Health Monitor](https://github.com/SovereignCloudStack/openstack-health-monitor/) (OSHM) runs and tests our partner's SCS installations and builds reports on Grafana dashboards. The OSHM has a long history and was once created for the OpenTelekomCloud, modeling a CloudFoundry deployment that was reported to not work reliably there. The [initial commit](https://github.com/SovereignCloudStack/openstack-health-monitor/commit/1de625b9b5534235a92e925226adea5a3c2d7507) into SCS was made in November 2019 by SCS CTO [Kurt Garloff](https://github.com/garloff). The OSHM went through multiple iterations of patches, mainly submitted by Kurt, but also by others from the community. The broad deployment of the OSHM in CSP sites offers insights that everyone benefits from. And they are openly available to the SCS community via the dashboards, which are linked on the [overview of "Compliant cloud environments"](https://docs.scs.community/standards/certification/overview) page, column *HealthMon*.

Up until now, the OSHM enriched the SCS development and testing workflows in many ways. But, with the advancement of Kubernetes-as-a-Service (KaaS) and the tooling for operations and security in SCS, the sole focus on OpenStack made us re-evaluating the extendability of the OSHM.

The OSHM is a very big shell script (nearly 5000 LoC) that is called with a lot of parameters on the CLI. It is able to export metrics to Grafana, via Telegraf and InfluxDB. As for the deployment, see [the run script for OSHM on gx-scs](https://github.com/SovereignCloudStack/openstack-health-monitor/blob/07b1f4ad0390382b3bf569139ad07dae186f5c33/run_gx_scs.sh), our main testing environment, as an example. While this works in SCS instances which employ OpenStack as the IaaS implementation, opening up the scope of the OSHM and bringing in entirely new platforms like Kubernetes and tools like Keycloak and Zuul were deemed to be difficult and time-consuming.

Therefore, other projects that might help to extend health monitoring for SCS were evaluated. The main goals to reach were:
1. Allowing the community (multiple people who might not know each other) being able to maintain the code,
3. using a framework that is extensible towards every component of SCS and
4. having an open-source code base (an established framework) to build upon.

We arrived at [the StackMon (CloudMon)](https://stackmon.org/) project, in which our collegue [Artem](https://github.com/gtema) is involved in. After an in-depth exchange workshop over the setup, possibilities and scope of StackMon, the SCSHM team got to work on a PoC for StackMon in SCS. Having gone through exploration and testing of StackMon as a candidate for an OSHM replacement, the team decided to switch to another approach.


## Concept

The new approach should lay a ground for testing not only OpenStack (a limiting disadvantage of both the OSHM and StackMon), but Kubernetes and applications on top as well. Originally, the team for the SCSHM work package (tender VP12) brought in their own technical proposal for a new implementation of a health monitoring stack. It was decided that this design was then used as a blueprint for all SCS components and layers, including OpenStack.

At the time of writing, the implementation of the SCS Health Monitor makes use of:
* the [Gherkin DSL](https://cucumber.io/docs/gherkin/reference/) in which test cases are written in a non-technical human-readable language,
* the [Behave](https://behave.readthedocs.io/en/latest/)/[BehaveX](https://github.com/hrcorval/behavex) libraries, which are written in Python and translate Gherkin into code,
* API clients for [OpenStack](https://docs.openstack.org/openstacksdk/latest/user/index.html), [Kubernetes](https://kubernetes.readthedocs.io/en/latest/) and any other application, and
* a Prometheus-based setup for exporting metrics.

Given that the implementation of API clients is done in Python, the framework is extensible to other tools as well (IAM, security, secrets, CI/CD, system monitoring). Most APIs in the SCS ecosystem are REST APIs exposed via HTTPS. Where there's no Python SDK or client library, we can fall back to plain HTTPS requests.

During test runs that are coordinated by Behave, metrics are collected. In the end, these are then pushed via a [Prometheus push gateway](https://prometheus.io/docs/practices/pushing/) towards a [Prometheus instance](https://prometheus.io/) and displayed in a [Grafana dashboard](https://grafana.com/). The code bases for test runs and the Prometheus stack are decoupled, any Prometheus installation can be used as export target.

So far the theory, let's dive into how to use the framework!



## Usage

The repo with the SCSHM's code is at [SovereignCloudStack/scs-health-monitor](https://github.com/SovereignCloudStack/scs-health-monitor). Let's start with a simple use case: Testing the creation and deletion of a network in OpenStack.

### Setup the test environment

This setup is simple and straight forward and shall lead you to have a quick, yet complete experience of running a test with the SCSHM. There's also a container-based approach in review in [PR #137](https://github.com/SovereignCloudStack/scs-health-monitor/pull/137). It uses podman to build a "runner" container and automates the deployment of the Prometheus stack.


```shell
# 1. Clone the repository
git clone https://github.com/SovereignCloudStack/scs-health-monitor
cd scs-health-monitor

# 2. Set up a virtual Python environment
# It's recommended to use a virtual environment to avoid conflicts with other Python packages.
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 3. Install Required Python Packages using pip.
pip install -r requirements.txt
```

In this repository (under main directory) you have to create the two files:
* `env.yaml` with SCSHM-related configuration ([example code](https://github.com/SovereignCloudStack/scs-health-monitor/blob/0f4f8a1d1c3bddadddc77e999167c939e1164320/env.example.yaml)) and
* `clouds.yaml` containing your clouds.yaml credentials for OpenStack ([example code](https://github.com/SovereignCloudStack/scs-health-monitor/blob/0f4f8a1d1c3bddadddc77e999167c939e1164320/clouds.example.yaml)).


### Running a test

Now that you have installed Behave and the necessary Python libraries, and configured your environment, it's time to run a test!

```shell
behave cloud_level_testing/features/openstack_create_network.feature cloud_level_testing/features/openstack_delete_network.feature
```

This test will, as mentioned before, create and delete a network in your OpenStack environment. Any results and errors will be catched and displayed. If everything works as expected, you should see an output similar to the following:

```gherkin
@network @create
Feature: OpenStack Network Creation # cloud_level_testing/features/openstack_create_network.feature:3

  Scenario Outline: Connect to OpenStack and create a network -- @1.1 Test networks  # cloud_level_testing/features/openstack_create_network.feature:12
    Given I connect to OpenStack                                                     # cloud_level_testing/features/steps/definitions.py:18 0.003s
    Then I should be able to create 2 networks                                       # cloud_level_testing/features/steps/definitions.py:153 2.498s
    Then I should be able to list networks                                           # cloud_level_testing/features/steps/definitions.py:147 0.147s

@network @cleanup
Feature: Delete openstack network # cloud_level_testing/features/openstack_delete_network.feature:3

  Scenario: Connect to OpenStack and delete a network  # cloud_level_testing/features/openstack_delete_network.feature:5
    Given I connect to OpenStack                       # cloud_level_testing/features/steps/definitions.py:18 0.003s
    Then I should be able to delete a networks         # cloud_level_testing/features/steps/definitions.py:245 1.823s

2 features passed, 0 failed, 0 skipped
2 scenarios passed, 0 failed, 0 skipped
5 steps passed, 0 failed, 0 skipped, 0 undefined
Took 0m4.474s
```

### Further usage and development

To add new behavior or extend existing features, first define new steps in the Python files located in `container_level_testing/features/steps` or `container_level_testing/features/steps`. These files map Gherkin steps to Python code. For example, see the following implementation of a `Given` and a `Then` step:

```python
@given('I have resource X with name {name} available')
def given_resource_x(context, name: str):
    resource = check_resource_exists(name)
    if resource is None:
        create_resource(name=name)

@when('I use resource with name {name} to do things')
def do_things_with_resource(context, name: str):
    resource = get_resource_by_name(name)
    assert resource is not None
    resource.run_function_that_does_something()

@then('Resource X with name {name} should be in working state')
def check_resource(context, name: str):
    resource = get_resource_by_name(name)
    assert resource is not None
    state = resource.get_state()
    assert state == "Running"
```

Then, create a new feature file by adding a new `.feature` file in the `features` directory. In it, write scenarios in the Gherkin syntax, defining the behavior you want to test using Given-When-Then steps:

```gherkin
Feature: New Kubernetes Feature

  Scenario Outline: Using resource X to do things
    Given I have resource X with name {name} available
    When I use resource with name {name} to do things
    Then Resource X with name {name} should be in working state

    Examples:
      | name     |
      | testname |
```

And done – you have successfully created a Given-When-Then scenario in both the code and Gherkin (even with a variable!).

Please also have a look [at the docs folder in the repo](https://github.com/SovereignCloudStack/scs-health-monitor/tree/main/docs) as well as the [documentation on docs.scs.community](https://docs.scs.community/docs/category/scs-health-monitor/).


## Outlook and future

For R7 the team has implemented much of the tests from the OSHM in the new SCSHM. During the work in the previous months, the coverage was tracked closely to ensure that the implementation is on track to be a serious replacement for the OSHM. If you wish to deploy the SCSHM, please reach out to us!

In regard to Kubernetes and applications there's some groundwork done. Given the stability of the framework itself, further extension of functionality and tests is pretty straight forward. We'll focus on Kubernetes and Cluster Stacks next, as to have a possibility to do health monitoring of KaaS deployments.

Feel free to open [a new feature request issue](https://github.com/SovereignCloudStack/scs-health-monitor/issues) in the repo and to try the tool yourself – be it on OpenStack or in Kubernetes!
