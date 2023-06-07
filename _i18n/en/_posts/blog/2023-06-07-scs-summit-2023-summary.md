---
layout: post
title:  "SCS Summit 2023 - a summary"
author:
  - "Friederike Zelke"
avatar:
  - "zelke.jpg"
image: "summit2023/banner.png"
about:
  - "Zelke"
---

Secure and digital sovereign cloud infrastructure is right now no longer an idea or an illusion. And also the definition of this often used term, that it is way more than mere legal compliance, becomes common, doesn't it?

At the SCS Summit it does. The Summit strikes a bow from the need of digital sovereignty to examples of implemented and operated digital sovereign infrastructure. Speakers and attendees from public administration, business companies, organizations, and the community came together to share their knowledge, experiences, concerns, and hopes. 

As the SCS is a publicly funded project Ernst Stöckl-Pukall as representitive of the BMWK the federal ministry of economics and climate and Rafael Laguna de La Vera from SPRIN-D the federal agency of leap innovations opened the summit with the story of SCS and why this project was worth to be started and funded - because to get a chance to become digital sovereign the base and IT infrastructure is needed! Martin Schallbruch and Silke Tessmann-Storch made it more tangible what it means for public administration to get digital sovereign with open source also for the "Verwaltungscloud". But digital sovereignty is not only needed in Germany, the panel proved that this is a European need. Europe is based on profound values, but the values of independence, freedom, security, openness stay unconcrete as long as the base for their practical realization is not implemented. And this implementations must be in Europe, we need the technology and the knowledge. That´s why SCS is so important. And we were quite lucky to elect a polical leadership who understands the need and the solution... 

The solutions SCS is offering is not only a base for European digital sovereignty. Martin Wimmer from BMZ introduced GovStack, an international initiative for digital collaboration. The ability to learn from each other, to share knowledge and technology and to understand even better is a chance for peace, health and wealth on a global level. SCS could become a global solution. So we are able to spread the values as well. 

Which values SCS is offering with its technical solution was subject in two panels when Kurt Garloff and Johan Christensen talk about the openness of SCS and how this openness foster a community, but also business. Collaboratively business was subject of the Open Operations panel where representitives and CEOs of cloud service providers and the community talked about the advantages of open source and transparent operations: even smaller teams are able to react fast and to strengthen the security.

With all these ideas, visions, and values digital sovereignty is not yet reality - also players, partners and the community are needed. That´s why these players, partners, and the community shared their experiences with SCS: cloud service providers like plusserver, Wavecon, and OSISM together with JH-Computers, integrator of the software solution of SCS B1 Systems, users and communities like GXFS and the University of applied Science Osnabrück, and business users like VOICE association and DATEV. And they all proved the advantages of the transparent, open source cloud instructure and the community are a perfect base for business, science, innovation, and digital sovereignty.

You will find the archived program page with all talks here <https://scs.community/summit2023/> 

## Selection of talks

<div class="row">
	<div class="col-lg-12">
		<div class="list-group mb-4">
    {% assign talks = site.data.summit2023-talks | where_exp: "talk", "talk.video != nil" %}
		{% for talk in talks %}
		<div class="list-group-item list-group-item-action align-items-start">
			<div class="d-flex w-100 justify-content-between">
				<div class="d-flex w-75 flex-column justify-content-start position-relative">
					<a href="{{talk.video}}" target="_blank" class="mb-1 text-decoration-none text-body stretched-link">{{talk.title}}</a>
					{% if talk.description %}<p class="mb-1 small fw-light">— {{ talk.description }}</p>{% endif %}
				</div>
				<div class="d-flex w-25 flex-column justify-content-start text-end position-relative">
					{% if talk.slides %}
						<a class="mt-1 text-decoration-none text-secondary stretched-link" href="{{talk.slides}}" target="_blank">
							<i class="fa fa-download my-auto"></i> <small>Slides</small>
						</a>
					{% endif %}
				</div>
			</div>
		</div>
		{% endfor %}
		</div>
	</div>
</div>

## Gallery

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/summit2023/gallery" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='SCS Summit 2023 Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>
