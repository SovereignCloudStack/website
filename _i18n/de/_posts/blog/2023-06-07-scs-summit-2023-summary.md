---
layout: post
title:  "SCS Summit 2023 - eine Zusammenfassung"
author:
  - "Friederike Zelke"
avatar:
  - "zelke.jpg"
image: "summit2023/banner.png"
about:
  - "Zelke"
---

Eine sichere und digital souveräne Cloud-Infrastruktur ist heute keine Idee oder Illusion mehr, sondern Realität. Und auch die Definition dieses oft verwendeten Begriffs, dass es sich um weit mehr als nur um die Einhaltung von Rechtsvorschriften handelt, setzt sich durch, oder?

Auf dem SCS Summit auf jeden Fall. Der Summit schlägt einen Bogen von der Notwendigkeit digitaler Souveränität zu Beispielen implementierter und betriebener digital-souveräner Infrastruktur. Referenten und Teilnehmer aus der öffentlichen Verwaltung, Unternehmen, Organisationen und der SCS Community kamen zusammen, um ihr Wissen, ihre Erfahrungen, Sorgen und Hoffnungen zu teilen.

Da der SCS ein öffentlich gefördertes Projekt ist, eröffneten Ernst Stöckl-Pukall als Vertreter des BMWK (Bundesministerium für Wirtschaft und Klimaschutz) und Rafael Laguna de La Vera von SPRIN-D, der Bundesagentur für Sprunginnovationen, den Summit mit der Geschichte des SCS und warum es sich lohnte, dieses Projekt zu starten und zu finanzieren - denn um eine Chance zu haben, digital souverän zu werden, braucht es die Basis und die IT-Infrastruktur! Martin Schallbruch und Silke Tessmann-Storch machten greifbar, was es für die öffentliche Verwaltung bedeutet, mit Open-Source auch mit der “Verwaltungscloud” digital-souverän zu werden.

Digitale Souveränität wird aber nicht nur in Deutschland gebraucht. Das mit Vertretern aus Politik und Wirtschaft hochkarätig besetzte Panel zeigte, dass dies eine europäische Notwendigkeit ist. Europa basiert auf Werten, aber diese Werte wie Unabhängigkeit, Freiheit, Sicherheit, Offenheit bleiben so lange unkonkret, wie die Basis für ihre praktische Umsetzung nicht geschaffen wird. Und diese Umsetzung muss in Europa erfolgen, wir brauchen die Technologie und das Wissen. Deshalb ist der SCS so wichtig. Und wir hatten das Glück, eine politische Führung zu wählen, die die Notwendigkeit und die Lösung verstanden hat…

Welche Werte SCS mit seiner technischen Lösung bietet, war Thema in zwei Panels, in denen zum Einen Kurt Garloff, CTO SCS, und Johan Christensen von Cleura über die Offenheit von SCS sprachen und wie diese Offenheit eine Community, aber auch das Geschäft fördert. Die geschäftliche Zusammenarbeit war Thema des Panels Open Operations, in dem Vertreter und CEOs von Cloud Service Providern und der Community über die Vorteile von Open-Source und transparenten Abläufen sprachen: Auch kleinere Teams sind in der Lage, schnell zu reagieren, sich gegenseitig zu unterstützen und Sicherheit zu garantieren.

Mit all diesen Ideen, Visionen und Werten ist digitale Souveränität noch nicht Realität - es braucht auch Akteure, Partner und die Community. Deshalb haben diese Akteure, Partner und die Community ihre Erfahrungen mit SCS geteilt: Cloud-Service-Provider wie plusserver, Wavecon und OSISM zusammen mit JH-Computers, dem Integrator der Softwarelösung von SCS B1 Systems, Anwender und Communities wie GXFS und der Fachhochschule Osnabrück sowie Business-Anwender wie der VOICE Verband und DATEV. Sie alle bewiesen, dass die Vorteile der transparenten, open-source Cloud-Infrastruktur und der Community eine perfekte Basis für Wirtschaft, Wissenschaft, Innovation und digitale Souveränität sind.

Die archivierte Seite mit dem gesamten Programm finden Sie unter: <https://scs.community/summit2023/> 

## Eine Auswahl der Vorträge

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

## Galerie

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
