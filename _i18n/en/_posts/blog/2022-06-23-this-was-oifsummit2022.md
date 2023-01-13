---
layout: post
title:  "OpenInfra Summit 2022 – Class reunion of our community"
author:
  - "Eduard Itrich"
  - "Felix Kronlage-Dammers"
avatar:
  - "eitrich.jpg"
  - "fkr.jpg"
image: "oif_summit2022/gallery/attatchment.IFDb2U.jpeg"
about:
  - "eitrich"
watchlist:
  - name: "Hardware Onboarding and Burn-in with Ironic in the CERN Data Center"
    url: "https://www.youtube.com/watch?v=9QRNEJX3SXQ"
  - name: "Confidential Computing in the Control Plane (case study using Barbican)"
    url: "https://www.youtube.com/watch?v=vh-Q9HWdYsQ"
  - name: "Ghosting the Spectre"
    url: "https://www.youtube.com/watch?v=p2mQeF3gd2Q"
  - name: "Honey, I Blew Up the Cloud"
    url: "https://www.youtube.com/watch?v=1zgT_7-QOw8"
  - name: "Past, present and future of the storage in the CERN private cloud"
    url: "https://www.youtube.com/watch?v=Ik9BMkFvsoI"
  - name: "Observability on public clouds"
    url: "https://www.youtube.com/watch?v=dRMpdz1lDH4"
  - name: "API Performance"
    url: "https://www.youtube.com/watch?v=OqcnXxTbIxk"
  - name: "OpenStack Plugin for Vault"
    url: "https://www.youtube.com/watch?v=RANhjX6-KYE"
  - name: "Project Necromancy"
    url: "https://www.youtube.com/watch?v=Ujq8I8wPpng?t=432"
---

Two weeks after this year's [OpenInfra Summit in Berlin]({% post_url blog/2022-06-02-scs-at-oifsummit2022 %})
we are still overwhelmed by the impressions of those three days at the Berlin Conference Center (bcc).
With our reference implementation being built upon OpenStack the OpenInfra Summit is the major conference
for us - obviously we brought our share of talks and contributions to the table as well.

A multitude of great speakers and the overall welcoming and motivating atmosphere made this event unique.
Many thanks to the whole [OpenInfra Foundation team](https://openinfra.dev/about/staff/) who made
this summit possible and to [FNTECH](https://www.fntech.com/) for the successful organization of
the event. You rock! 🤘

All of the talks at the Summit were recorded and are published. Within the SCS community we assembled a list of
talks that we thought were really great.

## Contributions and talk from the SCS communtiy

The first day started with keynotes and we were thrilled that PStS Dr. Brantner from the Federal Ministry of economic affairs and climate
action [shared her thoughts](https://www.youtube.com/watch?v=ZlPLGmBfaVc&t=4420s).
Eduard had the chance to present our views on [Digital sovereignty](https://www.youtube.com/watch?v=i2hQQFJi3Yo) and why open infrastructure
matters. The subject of digital sovereignty is important - as such Eduard was assigned [another slot on day two](https://www.youtube.com/watch?v=Lvz2PcHq0yY).

Kurt and Felix presented the [Open Operations concept](https://www.youtube.com/watch?v=oGuUty7ufN8) - maybe this will become the fifth _open paradigm_?
The talk was well received and sparked discussions around the hallway track. There was a forum session on Day three together with the folks from
[Operate First](https://www.operate-first.cloud/) on _Open Operations_ which featured a packed room. We will move this subject further and spark
more discussions and actions within our community.

The learnings and building blocks from our Special Interest Group Monitoring were presented by Felix and Mathias in their
talk on [Observability in OpenStack](https://www.youtube.com/watch?v=x9lk3Jk15Wc). 

<div class="row">
	<div class="col-lg-12">
		<div class="list-group mb-4">
		{% assign sorted = site.data.conferences_en | where: "event", "OpenInfra Summit 2022" | sort: 'date' %}
		{% for item in sorted %}
		<div class="list-group-item list-group-item-action align-items-start">
			<div class="d-flex w-100 justify-content-between">
				<div class="d-flex w-75 flex-column justify-content-start position-relative">
					<a href="{{item.link}}" target="_blank" class="mb-1 text-decoration-none text-body stretched-link">{{item.title}}</a>
					{% if item.details %}<p class="mb-1 small fw-light">— {{item.details}}</p>{% endif %}
				</div>
				<div class="d-flex w-25 flex-column justify-content-start text-end position-relative">
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


## Further sessions and recordings worth seeing

<div class="row">
	<div class="col-lg-12">
		<div class="list-group mb-4">
      {% for recording in page.watchlist %}
      <div class="list-group-item list-group-item-action align-items-start">
        <div class="d-flex w-100 justify-content-between">
  					<a href="{{recording.url}}" target="_blank" class="mb-1 text-decoration-none text-body stretched-link">{{recording.name}}</a>
        </div>   
      </div>
      {% endfor %}
    </div>
    </div>
</div>

## Gallery

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/oif_summit2022/gallery" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='Open Infra Summit 2022 Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>