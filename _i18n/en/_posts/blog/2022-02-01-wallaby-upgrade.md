---
layout: post
title:  "Sovereign Cloud Stack Community Plusserver Environment"
author: "Mathias Fechner"
---

_(By Markus Lindenblatt, Toens Bueker, Mathias Fechner)_

### One Wallaby Update Experience

Since more then one year Plusserver has provided the SCS Community Community Environment.
For the Plusserver SCS Community Environment we started our OpenStack Wallaby upgrade
in early December 2021, everything looked good and fine.

One cosmetic issue was, that the neutron-metadata-agent was missing in "openstack network agent list"
despite the agents being up and running.

After one week we detected that some OpenStack services like octavia, nova and cinder became non-responsive.
The reason could be traced back to the rabbitmq cluster, which was strangely running in a split brain fashion.
After cleaning up the rabbitmq cluster and re-deploying it, everything went back to normal again.
But it didn't take too long and services became non-responsive again... 
After an intensive diagnostic session we decided to roll rabbitmq back to the victoria container image version, 
which helped to work around this bug.

### what was the Problem?

We suspect https://github.com/rabbitmq/osiris/issues/53 being the culprit, which shows some issues with split brain situations
in Docker setups.

We have filed an issue against the osism testbed in order to see, when the bug is fixed (https://github.com/osism/testbed/issues/978).

### 
