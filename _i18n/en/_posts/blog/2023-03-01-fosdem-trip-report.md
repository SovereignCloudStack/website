---
layout: post
title: "SCS Team FOSDEM 2023 - Travel Report"
image: "blog/fosdem2023.png"
author:
  - "Felix Kronlage-Dammers"
  - "Max Wolfs"
avatar:
  - "fkr.jpg"
  - "mwolfs.jpg"
about:
  - "fkr"
---

Two weeks ago Europe's largest conference for free and open source took place in Brussels, Belgium.
[FOSDEM 2023](https://www.fosdem.org) is comprised of many so-called DevRooms, each of the rooms dedicated
to a certain topic or community.

Together with [Operate First](https://www.operate-first.cloud/), a collaborative initiative by RedHat, [MOC Alliance](https://massopen.cloud/)
and OpenInfra Labs, we organized the [Sovereign Cloud DevRoom](https://fosdem.org/2023/schedule/track/sovereign_cloud/).
As such most of the Saturday was spent in the Sovereign Cloud DevRoom. Thanks to a lot of awesome presenters
we've had a day full of interesting talks. For FOSDEM the topic was rather niche, yet the room was almost
always filled to at least 80% capacity and the feedback that we received at the end of the day gave us the
impression that it was not only well received but that people did actually take insights and learnings home
with them.

Max opened the Sovereign Cloud DevRoom presenting our insights of [wow we created a our documentation framework.](https://fosdem.org/2023/schedule/event/sovcloud_how_we_created_a_documentation_framework_that_works_across_a_group_of_vendors/). You can have a look at the result the which is our ever growing [documentation page](https://docs.scs.community).

After great talks posing questions around sustainability and the spicy topic of the global cloud landscape, it was Kurt's time to demystify an important term that has become a buzzword – [Digital Sovereignty](https://fosdem.org/2023/schedule/event/sovcloud_what_is_digital_sovereignty_and_how_can_oss_help_to_achieve_it/).

Saturday evening the [OpenInfra foundation](https://openinfra.dev) invited their friends to a meetup. A great way to connect with all
the folks from the OpenInfra community running around in Brussels and at FOSDEM. Among others, I had the chance
to get to know [Robert Holling](https://www.linkedin.com/feed/update/urn:li:activity:7028085889545207808/), who will be
presenting their [Open Campus Infrastructure powered by OpenStack](https://www.linkedin.com/feed/update/urn:li:activity:7029170851237257216/)
at this years [OpenInfra Summit](https://openinfra.dev/summit/vancouver-2023) in Vancouver.

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/blog/fosdem2023-travel" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='FOSDEM 2023 Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>

FOSDEM, which is completely run by volunteers, does have an amazing video team. All of the talks are recorded
as well as live streamed. Because of the recordings there is no reason to have the slightest fear of missing out.
This is yet another reason for me to spend time in the hallway track as well. FOSDEM is one of those conferences
where, if you want to catch a talk at a certain time, you have to start walking there an hour early, since otherwise
all the people you meet on the way will cause me to miss the talk ;)

I underestimated how much of the Saturday he'd spend in our DevRoom organizing, so this year's
Sunday was mostly about connecting with friends.
It was a weekend we spend reconnecting with lot's of friends and also have had the chance to spend time with
together as colleagues with [Kurt](https://www.linkedin.com/posts/kurt-garloff_fosdem23-sovereigncloud-openinfrastructure-activity-7028038003520368640-_4L1)
and Max. As much as we love working remote, it is always nice to hang out together in 3D ;)
