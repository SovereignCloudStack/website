---
layout: post
title:  "OpenInfra Summit 2022 – Class reunion of our community"
author:
  - "Eduard Itrich"
avatar:
  - "eitrich.jpg"
image: "oif_summit2022/countdown.jpg"
---

Two weeks after this year's [OpenInfra Summit in Berlin]({% post_url 2022-06-02-scs-at-oifsummit2022 %})
we are still overwhelmed by the impressions of this for us very important conference.
A multitude of great speakers and the overall welcoming and motivating atmosphere made this event unique.
Many thanks to the whole [OpenInfra Foundation team](https://openinfra.dev/about/staff/) who made
this summit possible and to [FNTECH](https://www.fntech.com/) for the successful organization of
the event. You rock! 🤘

With this blogpost we would like to provide you with the slides of our various presentations,
point out some recordings worth seeing and give you a preview of the next milestones in our project.

## Sessions and recordings worth seeing

<div class="row">
	<div class="col-lg-12">
		<div class="list-group mb-4">
		{% assign sorted = site.data.conferences_en | where: "event", "OpenInfra Summit 2022" | sort: 'date' %}
		{% for item in sorted %}
		<div class="list-group-item list-group-item-action align-items-start">
			<div class="d-flex w-100 justify-content-between">
				<div class="d-flex w-75 flex-column justify-content-start position-relative">
					<h5 style="font-size:.875em">{{item.event}}</h5>
					<a href="{{item.link}}" target="_blank" class="mb-1 text-decoration-none text-body stretched-link">{{item.title}}</a>
					{% if item.details %}<p class="mb-1 small fw-light">— {{item.details}}</p>{% endif %}
				</div>
				<div class="d-flex w-25 flex-column justify-content-start text-end position-relative">
					<small>{% include date.html date=item.date %}</small>
					{% if item.slides %}
						<a class="mt-1 text-decoration-none text-secondary stretched-link" href="{% asset '{{item.slides}}' @path %}" target="_blank">
							<i class="fa fa-download my-auto"></i> <small>{% t news.conference.slides %}</small>
						</a>
					{% endif %}
				</div>
			</div>
		</div>
		{% endfor %}
		</div>
	</div>
</div>

**TODO: Add image gallery**

**TODO: Add what's next section**