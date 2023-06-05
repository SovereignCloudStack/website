---
layout: post
title:  "Lean SCS Operator Coffee"
author:
  - "Felix Kronlage-Dammers"
avatar:
  - "fkr.jpg"
about:
  - "fkr"
image: "blog/coffeebeans.png"
---

Last week we've had the second edition of the "Lean SCS Operator Coffee". This format was sparked
by the R2 retro we had a while ago. From the community of the SCS Operators came the request to have
a format where the operators are able to interact and share their experiences in operating SCS
environments.

{% asset 'blog/coffeebeans.png' vips:format='.webp' style="width:100%; max-height: 450px; object-fit: cover;" %}

## Lean Coffee? 

How does "a lean coffee look like"?
Let's start with this quote from the [original website](http://leancoffee.org):

> Lean Coffee is a structured, but agenda-less meeting. Participants gather, build an agenda, and begin talking. Conversations are directed and productive because the agenda for the meeting was democratically generated.

Since the SCS community is distributed a remote-friendly way of organizing the Lean SCS Operator coffee
is anticipated. We chose a simple, yet useful (and open source) emulation of a kanban board: [scrumblr](https://github.com/aliasaria/scrumblr).

While we (the SCS team) organize the lean coffee, the agenda is made by the participants and I only try to moderate the dialogue and keep the discussion going.
Of course the board we use is [publicly available](https://scrumblr.ethibox.fr/9ucuscs-lean-coffee) as well.

## osism ops-tools 

The second edition of the Lean SCS Operator Coffee saw a strong participation from the team of [plusserver](https://www.plusserver.com). The first topic that
was discussed was their publication of their [OSISM ops-tools](https://github.com/plusserver/osism-opstools/). This contribution to the
[OSISM](https://github.com/osism/) landscape was warmly welcomed. Furthermore it was elaborated on how the process of open sourcing such
additions be further supported, for example by providing outlines for processes on releasing code from corporations into the open. A typical
hurdle is choosing the proper license. While this seems trivial for people with a lot of experience in working with open source communities for
companies starting to venture into this field this is a hurdle to tackle. One idea that I had was to provide the outlines that I've previously
gave colleagues to decide on a licence and incorporate that into our [scs docs](https://github.com/sovereignCloudStack/docs)..

Further discussions around osism and the handling of multiple inventories as well as multi-region handling arose and it was concluded that
a break out hands-on session on that subject together with colleagues from OSISM makes sense. This will be scheduled shortly.

## Open Operations @ Lean Coffee

Since Kurt and I recently presented our [view on open operations](https://www.youtube.com/watch?v=oGuUty7ufN8) at the open infra summit in Berlin this subject came up and the
scepticism towards public health dashboards with great details was discussed. While great detail is helpful for the ones who understand
the underlying technology these can also be a source for irritation for others. One idea that was discussed was that the [OpenStack Health Monitor](https://github.com/SovereignCloudStack/openstack-health-monitor)
should feature a simple dashboard that abstracts some of the detail and signals via red/orange/green whether metrics are within a certain
threshold.

## Next Lean SCS Operator Coffee?

The next edition of the Lean SCS Operator Coffee is planned for the 25th of July at 15:05 and will be [held on our jitsi](https://conf.scs.koeln:8443/SCS-Tech).
All our meetings can be seen [on our public calendar](https://scs.community/contribute/).

