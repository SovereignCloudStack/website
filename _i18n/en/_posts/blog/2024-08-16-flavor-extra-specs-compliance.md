---
layout: post
title:  "Getting SCS flavor properies into compliance"
category: tech
author:
- "Kurt Garloff"
- "Matthias Büchse"
avatar:
- "garloff.jpg"
about:
- "garloff"
---

## Non-compliance with flavor spec v4

Running the SCS IaaS compatible v4 checks against a cloud may reveal missing
mandatory flavor properties (aka `extra_specs`):
```shell
garloff@kurt: ~/SCS/standards/Tests$ ./scs-compliance-check.py -a os_cloud=$OS_CLOUD -s $OS_CLOUD scs-compatible-iaas.yam
Testing SCS Compatible IaaS version v4                                                                                                  
*******************************************************                                                                                 
Testing standard OpenStack Powered Compute v2022.11 ...                                                                                 
Reference: https://opendev.org/openinfra/interop/src/branch/master/guidelines/2022.11.json ...
WARNING: No check tool specified for OpenStack Powered Compute v2022.11
*******************************************************
Testing standard Flavor naming ... 
Reference: https://raw.githubusercontent.com/SovereignCloudStack/standards/main/Standards/scs-0100-v3-flavor-naming.md ...

... returned 0 errors, 0 aborts
*******************************************************
Testing standard Entropy ...
[...]
WARNING: VM 'Debian 12' doesn't provide the recommended service rngd 
DEBUG: Deleting server '_scs-0101-server'
DEBUG: Total critical / error / warning: 0 / 0 / 1
... returned 0 errors, 0 aborts
*******************************************************
Testing standard Image metadata ...
Reference: https://raw.githubusercontent.com/SovereignCloudStack/standards/main/Standards/scs-0102-v1-image-metadata.md ...
Warning: Image "Ubuntu Minimal 24.04" does not start with recommended name "Ubuntu 24.04"
[...]
Info: Image VyOS 1.4 rolling 20221121 has image_source set to private
... returned 0 errors, 0 aborts
*******************************************************
Testing standard Standard flavors ...
Reference: https://raw.githubusercontent.com/SovereignCloudStack/standards/main/Standards/scs-0103-v1-standard-flavors.md ...
DEBUG: Fetching flavors from cloud 'REDACTED'
DEBUG: Checking 28 flavor specs against 96 flavors
WARNING: Flavor 'SCS-1V-4' found via name only, missing property 'scs:name-v2'
ERROR: Flavor 'SCS-1V-4' violating property constraints: cpu-type: None should be 'shared-core'; name-v1: None should be 'SCS-1V:4'; nam
e-v2: None should be 'SCS-1V-4'
[...]
WARNING: Flavor 'SCS-1L-1-5' found via name only, missing property 'scs:name-v2'                                                        
ERROR: Flavor 'SCS-1L-1-5' violating property constraints: cpu-type: None should be 'crowded-core'; name-v1: None should be 'SCS-1L:1:5'
; name-v2: None should be 'SCS-1L-1-5'                                                                                                  
DEBUG: Total critical / error / info: 0 / 28 / 0                                                                                        
... returned 28 errors, 0 aborts                                                                                                        
*******************************************************                                                                                 
Testing standard Standard images ...                                                                                                    
Reference: https://raw.githubusercontent.com/SovereignCloudStack/standards/main/Standards/scs-0104-v1-standard-images.md ...            
DEBUG: Fetching image list from cloud 'plus-garloff1'                                                                                   
DEBUG: Images present: AlmaLinux 8, AlmaLinux 9, CirrOS 0.6.1, Debian 11, Debian 12, Fedora 37, Flatcar Container Linux 3510.2.8, Flatca
r Container Linux 3602.2.2, Flatcar Container Linux 3815.2.0, Flatcar Container Linux 3815.2.5, PSKE Flatcar Container Linux Stable, PSK
E Ubuntu 22.04 20240701, Ubuntu 20.04, Ubuntu 22.04, Ubuntu 24.04, Ubuntu Minimal 20.04, Ubuntu Minimal 22.04, Ubuntu Minimal 24.04, VyO
S 1.4 rolling 20221121, openSUSE 15.4, openSUSE 15.4 20230212                                                                           
DEBUG: Checking 6 image specs against 21 images                                                                                         
WARNING: Missing recommended image 'ubuntu-capi-image'                                                                                  
DEBUG: Missing optional image 'Debian 10'                                                                                               
DEBUG: Total critical / error / warning: 0 / 0 / 1                                                                                      
... returned 0 errors, 0 aborts                                                                                                         
*******************************************************                                                                                 
Verdict for subject REDACTED, SCS Compatible IaaS, version v4: 28 ERRORS                                                           
```

Let's quickly look at these results: We passed all compliance checks (some with warnings),
except for receiving 28 errors on the 15 mandatory and 13 recoemmended flavors.

## Mandatory flavor properties

The test tool provides the reference to the spec that we need to fulfill:
https://raw.githubusercontent.com/SovereignCloudStack/standards/main/Standards/scs-0103-v1-standard-flavors.md
Let's look at the relevant section in the rendered version
[here](https://docs.scs.community/standards/scs-0103-v1-standard-flavors#properties-extra_specs):
We lack the `scs:name-v1`, `scs:name-v2`, `scs:cpu-type` and `scs:diskN-type` flavor properties (`extra_specs`).

These properties were introduced in February 2024 and adopted for SCS compatible IaaS v4 compliance.

The rationale for these properties is a response for requests from our partners, some of which
dislike mandating naming conventions for flavors. The SCS standardization SIG has thus chosen
a strategy where we work on improving discoverability and contribute to common tools.
Medium term, this means that we can allow arbitrary names which may please marketing departments
better, yet still provide a way for users to systematically and automatically identify the flavors
they need by properties across all SCS compliant clouds and can express this in their IaC tooling.

The vision is a way for users to express "please give me the flavor that most closely matches
these minimum requirements". Requirements express things like number and kind of vCPUs,
RAM, size and type of root disk (if any), and also optionally extra requirements such as
support for hardware virtualization or GPU types, generation and VRAM size. Some work on
the SDK and opentofu will be required for this, at least.

The added properties are a first step to prepare for this freedom.

## Adding in missing properties

Fresh installations of the SCS R6 (OSISM 7) reference implementation will automatically have
all the needed properties; the OSISM flavor-manager takes care of creating the mandatory
(and recommended) flavors and setting all needed properties. Environments that have a
longer history need to go through some extra steps.

### Using OSISM flavor-manager to add missing properties (recommended)

The addition of the missing properties for users of the SCS reference
implementation OSISM happens in two steps:
1. Ensure your cloud is running SCS R6 (OSISM 7) or newer.
2. Call `osism manage flavors` on the manager node.

If you are on an old version of the SCS reference implementation, step 1 will of
course require careful testing and planning. Updating quickly to the latest SCS
reference implementation version however is a requirement to be supported and
be covered by security maintenance, so this is something that is overdue anyway.

Step 2 is as easy as it can be,
To demonstrate, I (with admin power) remove the needed properties for two flavors
on my Cloud-in-a-Box system:
```shell
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

As expected.

And the fix is as easy as it can get:
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

With the test now passing again.

### Using `flavor-add-extra-specs.py`

If you have SCS R6 (OSISM 7) or later, you should use the `osism manage flavors` to fix your
flavor properties.

There may be scenarios, where this does not fit, however:
* You are not using the SCS IaaS reference implementation (OSISM) at all or your are stuck
  with an old versions. You could still use the flavor manager, but you shy away from the
  effort to extract it from its native environment.
* You want to apply the systematic properties also to non-mandatory (and non-recommended)
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
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [2]$ ./flavor-naming/flavor-add-extra-specs.py 
INFO  SCS-8V-32: Update extra_spec scs:name-v2 to SCS-8V-32
INFO  SCS-8V-32: Update extra_spec scs:name-v3 to SCS-8V-32
INFO  SCS-8V-32: Update extra_spec scs:name-v1 to SCS-8V:32
INFO  SCS-8V-32: Update extra_spec scs:cpu-type to shared-core
INFO  SCS-4V-16: Update extra_spec scs:name-v2 to SCS-4V-16
INFO  SCS-4V-16: Update extra_spec scs:name-v3 to SCS-4V-16
INFO  SCS-4V-16: Update extra_spec scs:name-v1 to SCS-4V:16
INFO  SCS-4V-16: Update extra_spec scs:cpu-type to shared-core
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ openstack flavor show SCS-8V-32
+----------------------------+-------------------------------------------------------------------------------------------------------+
| Field                      | Value                                                                                                 |
+----------------------------+-------------------------------------------------------------------------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                                                                                 |
| OS-FLV-EXT-DATA:ephemeral  | 0                                                                                                     |
| access_project_ids         | None                                                                                                  |
| description                | None                                                                                                  |
| disk                       | 0                                                                                                     |
| id                         | bfafc738-9527-4082-820e-ee04fea1c76a                                                                  |
| name                       | SCS-8V-32                                                                                             |
| os-flavor-access:is_public | True                                                                                                  |
| properties                 | scs:cpu-type='shared-core', scs:name-v1='SCS-8V:32', scs:name-v2='SCS-8V-32', scs:name-v3='SCS-8V-32' |
| ram                        | 32768                                                                                                 |
| rxtx_factor                | 1.0                                                                                                   |
| swap                       | 0                                                                                                     |
| vcpus                      | 8                                                                                                     |
+----------------------------+-------------------------------------------------------------------------------------------------------+
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
garloff@framekurt(ciab-admin):/casa/src/SCS/standards/Tests/iaas [0]$ 
```

