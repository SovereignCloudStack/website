---
layout: post
title:  "Sovereign Cloud Stack Community plusserver Environment"
avatar: 
  - "avatar-pluscloudopen.png"
image: "blog/wallaby.jpg"
author: 
  - "Mathias Fechner"
  - "Toens Bueker"
  - "Markus Lindenblatt"
---
### One Wallaby Update Experience

Since more then one year plusserver has provided the SCS Community Environment which is based on osism OpenStack Distrubution.

For the plusserver SCS Community Environment we started our OpenStack Wallaby upgrade
in early December 2021 everything looked good and fine.

One cosmetic issue was, that the neutron-metadata-agent was missing in "openstack network agent list"
despite the agents being up and running.

After one week we detected that some OpenStack services like octavia, nova and cinder became non-responsive.
The reason could be traced back to the rabbitmq cluster, which was strangely running in a split brain fashion.
After cleaning up the rabbitmq cluster and re-deploying it, everything went back to normal again.
But it didn't take too long and services became non-responsive again... 
After an intensive diagnostic session we decided to roll rabbitmq back to the victoria container image version, which helped to work around this bug.

### What was the Problem ?

Rabbitmq is the Messagebroker Cluster in the Sovereign Cloud Stack and core infrastructure component,
it is a container based setup. From Victoria to Wallaby it has to switched form 3.8 tree to 3.9 tree 

In the [Changelog](https://www.rabbitmq.com/changelog.html) of rabbitmq we found some traces.

In the very early 3.9 (3.9.9) Rabbitmq releases was some issues:
We suspect this [issue](https://github.com/rabbitmq/osiris/issues/53) being the culprit, 
which shows some issues with split brain situations in Container based setups.
And finaly we assume it is fixed in rabbitmq 3.9.13

We have filed an issue against the osism testbed in order to see, when the [Bug](https://github.com/osism/testbed/issues/978) is fixed.
