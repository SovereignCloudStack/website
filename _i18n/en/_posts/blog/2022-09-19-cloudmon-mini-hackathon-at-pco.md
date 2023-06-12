---
layout: post
title:  "CloudMon Mini-Hackathon at PCO"
author:
  - "Felix Kronlage-Dammers"
avatar:
  - "fkr.jpg"
about:
  - "fkr"
image: "blog/ecos.jpg"
---

<figure class="figure mx-auto d-block" style="width:50%">
    {% asset 'blog/ecos.jpg' class="figure-img w-100" %}
</figure>

This was the first impression when I arrived at the new [plusserver](https://www.plusserver.com/)
office, which is located at the
[ECOS Co-Workingspace](https://www.ecos-office.com/en/locations/bielefeld/coworking)
in Bielefeld, for the CloudMon Mini-Hackathon last thursday. Aside from now [being assured that Bielefeld
really does exists](https://en.wikipedia.org/wiki/Bielefeld_conspiracy) (haha ;) - I had a blast.

## Commitment from the team

Ralf (Architect SCS & Open Source at plusserver) and I had the idea for the hackathon
a while back in order to get people working on the new version of
[CloudMon](https://github.com/stackmon/cloudmon) together. The complete
squad working on the [pluscloud open](https://www.plusserver.com/en/products/pluscloud-open)
as well as Artem from [Open Telekom Cloud](https://open-telekom-cloud.com/en/)
(who is the author of CloudMon) came to Bielefeld to spend a day getting their hands
wet on CloudMon. Ralf managed to get everyone to Bielefeld in person. In times
of a lot of remote meetings this was fantastic, since it does help to collaborate
remotely if people have met in real before. Furthermore it was nice to actually
work on a physical flipchart and discuss the architecture of CloudMon.
Thanks from my side to everyone who did not fear the traintravel to Bielefeld!

## OpenStack Health Monitor? ApiMon? CloudMon?

CloudMon, for SCS the designated successor for the OpenStack Health Monitor, has
been the primary subject of a few of our Open Hacking Sessions, which typically take
place friday afternoon) but so far, we did not manage to gain major velocity.
With the Mini-Hackathon Ralf and I wanted to lay the groundwork in order to give
our efforts more traction.

### Behaviour-driven Monitoring

What does CloudMon do? CloudMon is a set of components that allow to run ansible-based
playbooks that will run various commands via the OpenStack SDk and thus via the API of
an OpenStack-based cloud to test the functionality and note the behaviour of the cloud.

The biggest hurdle so far is, that bootstrapping CloudMon for a new environment is
not documented - this will be the first large contribution from outside the Open Telekom
Cloud, since having a good documentation on how to bootstrap CloudMon will help so that
others can contribute more easily to the further development.
So far CloudMon is living in the namespace of the OTC. Artem's idea is to lift the
development of CloudMon into a more independent place - so that the various communities
can contribute more easily.

### SIG Monitoring

The effort around CloudMon takes places within the Special Interest Group (SIG) Monitoring
at SCS. If you want to find out more about what the SIG Monitoring has been working
on I recommend the article on [Observability in OpenStack](https://www.linux-magazin.de/ausgaben/2022/10/observability-fuer-openstack/)
that was published in the german Linux Magazine recently. The SIG Monitoring is one of
those really good examples around the SCS community where collaboration is really lived
and not just spoken about.

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/blog/20220915-hackathon-pco" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='CloudMon Mini Hackathon Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>
