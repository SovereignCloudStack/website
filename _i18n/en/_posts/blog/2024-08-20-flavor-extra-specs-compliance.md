---
layout: post
title:  "Getting SCS flavor properties into compliance"
category: tech
author:
- "Kurt Garloff"
- "Matthias Büchse"
avatar:
- "kgarloff.jpg"
- "mbuechse.jpg"
about:
- "garloff"
- "mbuechse"
---

## Non-compliance with flavor spec v4

Running the SCS IaaS compatible v4 checks against a cloud may reveal missing
mandatory flavor properties (aka `extra_specs`):

```shell
garloff@kurt: ~/SCS/standards/Tests$ ./scs-compliance-check.py -a os_cloud=$OS_CLOUD -s REDACTED scs-compatible-iaas.yaml
INFO: module opc-v2022.11 missing checks or test cases
DEBUG: Fetching flavors from cloud 'REDACTED'
DEBUG: Checking 28 flavor specs against 97 flavors
WARNING: Flavor 'SCS-1V-4' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-1V-4' violating property constraints: cpu-type: None should be 'shared-core'; name-v1: None should be 'SCS-1V:4'; nam e-v2: None should be 'SCS-1V-4'
[...]
WARNING: Flavor 'SCS-1L-1-5' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-1L-1-5' violating property constraints: cpu-type: None should be 'crowded-core'; name-v1: None should be 'SCS-1L:1:5'
; name-v2: None should be 'SCS-1L-1-5'
DEBUG: Total critical / error / info: 0 / 28 / 0
********************************************************************************
REDACTED SCS-compatible IaaS v4 (effective):
- main: FAIL (4 passed, 1 failed)
  - FAILED:
    - standard-flavors-check:
      > Must fulfill all requirements of https://docs.scs.community/standards/scs-0103-v1-standard-flavors
```

Let's quickly look at these results: We passed all compliance checks
except for receiving 28 errors on the 15 mandatory and 13 recommended flavors.

With such errors, the cloud won't pass SCS-compatible IaaS compliance checks and show up
as failing on the [SCS compliance overview](https://docs.scs.community/standards/certification/overview).

## Mandatory flavor properties

The test tool provides the reference to the spec that we need to fulfill:
<https://docs.scs.community/standards/scs-0103-v1-standard-flavors>
Let's look at the [relevant section](https://docs.scs.community/standards/scs-0103-v1-standard-flavors/#guarantees-and-properties):
We lack the `scs:name-v1`, `scs:name-v2`, `scs:cpu-type` and `scs:disk0-type` flavor properties (`extra_specs`).

These properties were introduced in February 2024 and adopted for SCS-compatible IaaS v4 compliance.

### Background: Why these properties?

The rationale for these properties is a response to requests from our partners, some of which
dislike mandating naming conventions for flavors. The SCS standardization SIG has thus chosen
a strategy where we work on improving discoverability and contribute to common tools.
Medium term, this means that we can allow arbitrary names which may please marketing departments
and maybe customers better, yet still provide a way for users to systematically and automatically
identify the flavors they need by properties across all SCS compliant clouds and can express this
in their IaC tooling.

The vision is a way for users to express "please give me the flavor that most closely matches
these minimum requirements" with common tooling.
Requirements express things like number and kind of vCPUs,
RAM, size and type of root disk (if any), and also optionally extra requirements such as
support for hardware virtualization or GPU types, generation and VRAM size. Some work on
the SDK and opentofu will be required for this in addition to better discoverability, at least.

The added properties are a first step to prepare for this freedom.

## Adding in missing properties

Fresh installations of the SCS R6 (OSISM 7) reference implementation will automatically have
all the needed properties; the [OpenStack Flavor Manager](https://docs.scs.community/docs/iaas/components/flavor-manager)
by OSISM takes care of creating the mandatory
(and recommended) flavors and setting all needed properties. Environments that have a
longer or different history may need to go through some extra steps.

### Using Flavor Manager to add missing properties (recommended)

The addition of the missing properties for operators of the SCS reference
implementation OSISM happens in two steps:

1. Ensure your cloud is running SCS R6 (OSISM 7) or newer.
2. Call `osism manage flavors` on the manager node.

If you are on an old version of the SCS reference implementation, step 1 will of
course require careful testing and planning. Updating soon to the latest SCS
reference implementation version however is a requirement to be supported and
be covered by security maintenance, so this is something that at the time of
this posting is overdue anyway and should be planned for with high priority.

Step 2 is as easy as it can be.
To demonstrate, I (with admin power) remove the needed properties for two flavors
on my Cloud-in-a-Box (CiaB) system:

```shell
dragon@manager:~$ export OS_CLOUD=admin
dragon@manager:~$ openstack flavor set --no-property SCS-8V-32 
dragon@manager:~$ openstack flavor set --no-property SCS-4V-16
dragon@manager:~$ openstack flavor show SCS-8V-32
+----------------------------+--------------------------------------+
| Field                      | Value                                |
+----------------------------+--------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                |
| OS-FLV-EXT-DATA:ephemeral  | 0                                    |
| access_project_ids         | None                                 |
| description                | None                                 |
| disk                       | 0                                    |
| id                         | bfafc738-9527-4082-820e-ee04fea1c76a |
| name                       | SCS-8V-32                            |
| os-flavor-access:is_public | True                                 |
| properties                 |                                      |
| ram                        | 32768                                |
| rxtx_factor                | 1.0                                  |
| swap                       | 0                                    |
| vcpus                      | 8                                    |
+----------------------------+--------------------------------------+
```

The compliance test would now report two errors for those two flavors.
(I call the test tool directly for brevity here.)

```shell
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ ./standard-flavors/flavors-openstack.py -c $OS_CLOUD scs-0103-v1-flavors.yaml 
WARNING: Flavor 'SCS-4V-16' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-4V-16' violating property constraints: cpu-type: None should be 'shared-core'; name-v1: None should be 'SCS-4V:16'; name-v2: None should be 'SCS-4V-16'
WARNING: Flavor 'SCS-8V-32' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-8V-32' violating property constraints: cpu-type: None should be 'shared-core'; name-v1: None should be 'SCS-8V:32'; name-v2: None should be 'SCS-8V-32'
WARNING: Missing recommended flavor 'SCS-1V-4-10'
WARNING: Missing recommended flavor 'SCS-2V-8-20'
WARNING: Missing recommended flavor 'SCS-4V-16-50'
WARNING: Missing recommended flavor 'SCS-8V-32-100'
WARNING: Missing recommended flavor 'SCS-1V-2-5'
WARNING: Missing recommended flavor 'SCS-2V-4-10'
WARNING: Missing recommended flavor 'SCS-4V-8-20'
WARNING: Missing recommended flavor 'SCS-8V-16-50'
WARNING: Missing recommended flavor 'SCS-16V-32-100'
WARNING: Missing recommended flavor 'SCS-1V-8-20'
WARNING: Missing recommended flavor 'SCS-2V-16-50'
WARNING: Missing recommended flavor 'SCS-4V-32-100'
WARNING: Missing recommended flavor 'SCS-1L-1-5'
standard-flavors-check: FAIL
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [2]$
```

As expected, failure for two flavors, exit code 2.

And the fix is as easy as it can get and only takes a few seconds:

```shell
dragon@manager:~$ osism manage flavors 
dragon@manager:~$ openstack flavor show SCS-8V-32
+----------------------------+------------------------------------------------------------------------------+
| Field                      | Value                                                                        |
+----------------------------+------------------------------------------------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                                                        |
| OS-FLV-EXT-DATA:ephemeral  | 0                                                                            |
| access_project_ids         | None                                                                         |
| description                | None                                                                         |
| disk                       | 0                                                                            |
| id                         | bfafc738-9527-4082-820e-ee04fea1c76a                                         |
| name                       | SCS-8V-32                                                                    |
| os-flavor-access:is_public | True                                                                         |
| properties                 | scs:cpu-type='shared-core', scs:name-v1='SCS-8V:32', scs:name-v2='SCS-8V-32' |
| ram                        | 32768                                                                        |
| rxtx_factor                | 1.0                                                                          |
| swap                       | 0                                                                            |
| vcpus                      | 8                                                                            |
+----------------------------+------------------------------------------------------------------------------+
```

The tests are now passing again.
All operators of the SCS R6 (OSISM 7) or later can stop reading here.

### Using `flavor-add-extra-specs.py` (for special cases)

If you have SCS R6 (OSISM 7) or later, you should use the `osism manage flavors` to fix your
flavor properties, see above.

There may be scenarios, where this does not fit, however:

- You are not using the SCS IaaS reference implementation (OSISM) at all or your are stuck
  with an old version. You could still use the flavor manager, but you may shy away from the
  effort to extract it from its native environment.
- You want to apply the systematic properties also to non-mandatory (and non-recommended)
  flavors, in order to provide better ways for your customers to programmatically
  identify flavor properties.

In that case, there is a tool for you that uses the OpenStack APIs to add properties
(`extra_specs`) to existing flavors. It is available in the 
[`feat/flavor0103-add-extras` branch](https://github.com/SovereignCloudStack/standards/tree/feat/flavor0103-add-extras)
of the SCS standards repository in the 
[`Tests/iaas/flavor-naming/`](https://github.com/SovereignCloudStack/standards/tree/feat/flavor0103-add-extras/Tests/iaas/flavor-naming) directory.
(The reason it is only available in a branch is an ongoing strategic discussion in 
[PR #645](https://github.com/SovereignCloudStack/standards/pull/645). Feel free to add
your thoughts.)

Let's go through the steps of breaking the CiaB and having it fixed again:

```shell
garloff@framekurt():/casa/src/SCS/standards/Tests/iaas [0]$ export OS_CLOUD=ciab-admin
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ ./standard-flavors/flavors-openstack.py -c $OS_CLOUD scs-0103-v1-flavors.yaml 
WARNING: Missing recommended flavor 'SCS-1V-4-10'
WARNING: Missing recommended flavor 'SCS-2V-8-20'
WARNING: Missing recommended flavor 'SCS-4V-16-50'
WARNING: Missing recommended flavor 'SCS-8V-32-100'
WARNING: Missing recommended flavor 'SCS-1V-2-5'
WARNING: Missing recommended flavor 'SCS-2V-4-10'
WARNING: Missing recommended flavor 'SCS-4V-8-20'
WARNING: Missing recommended flavor 'SCS-8V-16-50'
WARNING: Missing recommended flavor 'SCS-16V-32-100'
WARNING: Missing recommended flavor 'SCS-1V-8-20'
WARNING: Missing recommended flavor 'SCS-2V-16-50'
WARNING: Missing recommended flavor 'SCS-4V-32-100'
WARNING: Missing recommended flavor 'SCS-1L-1-5'
standard-flavors-check: PASS
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ openstack flavor set --no-property SCS-4V-16
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ openstack flavor set --no-property SCS-8V-32
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ openstack flavor show SCS-8V-32
+----------------------------+--------------------------------------+
| Field                      | Value                                |
+----------------------------+--------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                |
| OS-FLV-EXT-DATA:ephemeral  | 0                                    |
| access_project_ids         | None                                 |
| description                | None                                 |
| disk                       | 0                                    |
| id                         | bfafc738-9527-4082-820e-ee04fea1c76a |
| name                       | SCS-8V-32                            |
| os-flavor-access:is_public | True                                 |
| properties                 |                                      |
| ram                        | 32768                                |
| rxtx_factor                | 1.0                                  |
| swap                       | 0                                    |
| vcpus                      | 8                                    |
+----------------------------+--------------------------------------+
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ ./standard-flavors/flavors-openstack.py -c $OS_CLOUD scs-0103-v1-flavors.yaml 
WARNING: Flavor 'SCS-4V-16' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-4V-16' violating property constraints: cpu-type: None should be 'shared-core'; name-v1: None should be 'SCS-4V:16'; name-v2: None should be 'SCS-4V-16'
WARNING: Flavor 'SCS-8V-32' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-8V-32' violating property constraints: cpu-type: None should be 'shared-core'; name-v1: None should be 'SCS-8V:32'; name-v2: None should be 'SCS-8V-32'
WARNING: Missing recommended flavor 'SCS-1V-4-10'
[...]
WARNING: Missing recommended flavor 'SCS-1L-1-5'
standard-flavors-check: FAIL
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ flavor-naming/flavor-add-extra-specs.py -a apply
INFO: Flavor SCS-8V-32: SET scs:cpu-type=shared-core
INFO: Flavor SCS-8V-32: SET scs:name-v1=SCS-8V:32
INFO: Flavor SCS-8V-32: SET scs:name-v2=SCS-8V-32
INFO: Flavor SCS-4V-16: SET scs:cpu-type=shared-core
INFO: Flavor SCS-4V-16: SET scs:name-v1=SCS-4V:16
INFO: Flavor SCS-4V-16: SET scs:name-v2=SCS-4V-16
INFO: Processed 16 flavors, 6 changes
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ openstack flavor show SCS-8V-32
+----------------------------+------------------------------------------------------------------------------+
| Field                      | Value                                                                        |
+----------------------------+------------------------------------------------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                                                        |
| OS-FLV-EXT-DATA:ephemeral  | 0                                                                            |
| access_project_ids         | None                                                                         |
| description                | None                                                                         |
| disk                       | 0                                                                            |
| id                         | bfafc738-9527-4082-820e-ee04fea1c76a                                         |
| name                       | SCS-8V-32                                                                    |
| os-flavor-access:is_public | True                                                                         |
| properties                 | scs:cpu-type='shared-core', scs:name-v1='SCS-8V:32', scs:name-v2='SCS-8V-32' |
| ram                        | 32768                                                                        |
| rxtx_factor                | 1.0                                                                          |
| swap                       | 0                                                                            |
| vcpus                      | 8                                                                            |
+----------------------------+------------------------------------------------------------------------------+
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ ./standard-flavors/flavors-openstack.py -c $OS_CLOUD scs-0103-v1-flavors.yaml 
WARNING: Missing recommended flavor 'SCS-1V-4-10'
[...]
WARNING: Missing recommended flavor 'SCS-1L-1-5'
standard-flavors-check: PASS
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ 
```

With `-a report` (or with the default `-a ask`) you could have reviewed the changes
to the flavor properties (`extra_specs`) prior to applying them.

### Bonus usage (not needed for compliance) for special flavors

If you define flavors outside of the SCS namespace, e.g. want to name your machine learning
flavors `ai.GPU.N`, you would still recommended to use the
[SCS flavor naming spec](https://docs.scs.community/standards/scs-0100-v3-flavor-naming)
to set the flavor `extra_specs` for transparency and discoverability.
You would go to the [flavor name generator](https://flavors.scs.community/), and enter
all details that you guarantee that these flavors have.
You might end up with a name like `SCS-16T-64-200s_kvm_hwv_z4h_GNl-142`, an
SCS flavor with 16 High Perf AMD Zen 4 SMT Threads with 64.0 GiB RAM on KVM with HW virt and SSD 200GB
root volume and Pass-Through GPU nVidia AdaLovelace (w/ 142 SM). (This is an nVidia L40.)
So you might create your host aggregates and create the flavor:

```shell
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas/flavor-naming [2]$ openstack flavor create --vcpu 16 --ram 65536 --disk 200 --property scs:name-v2=SCS-16T-64-200s_kvm_hwv_z4h_GNl-142 ai.l40.16
+----------------------------+---------------------------------------------------+
| Field                      | Value                                             |
+----------------------------+---------------------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                             |
| OS-FLV-EXT-DATA:ephemeral  | 0                                                 |
| description                | None                                              |
| disk                       | 200                                               |
| id                         | 02571f08-afce-4820-beb9-bcd464444338              |
| name                       | ai.l40.16                                         |
| os-flavor-access:is_public | True                                              |
| properties                 | scs:name-v2='SCS-16T-64-200s_kvm_hwv_z4h_GNl-142' |
| ram                        | 65536                                             |
| rxtx_factor                | 1.0                                               |
| swap                       | 0                                                 |
| vcpus                      | 16                                                |
+----------------------------+---------------------------------------------------+
```

You could use the tool now to fill in the additional properties:

```shell
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas/flavor-naming [0]$ ./flavor-add-extra-specs.py -A -a apply ai.l40.16
INFO: Flavor ai.l40.16: SET scs:cpu-type=dedicated-thread
INFO: Flavor ai.l40.16: SET scs:name-v1=SCS-16T:64:200s-kvm-hwv-z4h-GNl:142
INFO: Flavor ai.l40.16: SET scs:name-v3=SCS-16T:64:200s-GNl:142
INFO: Flavor ai.l40.16: SET scs:name-v4=SCS-16T-64-200s_GNl-142
INFO: Flavor ai.l40.16: SET scs:disk0-type=ssd
INFO: Processed 1 flavors, 5 changes
```

The additional names as well as `cpu-type` and `disk0-type` have been filled in,
as all the information was available thanks to the already set `scs:name-v2`.
The recommended less detailed name is in `scs:name-v4`.
