# Sovereign Cloud Stack Summit 2023

Liebe Freunde und interessierte Beobachter von SCS,

der Sovereign Cloud Stack ist erfolgreich im zweiten Jahr angekommen und hat eine aktive Community etabliert, die einen standardisierten Open Source Cloud Computing Stack entwickelt und pflegt. Erfolg heißt, dass wir die vierte Version herausgebracht haben und  drei Cloud Service Provider ihr Angebot auf SCS Standards und Technologie bereitstellen. Grund genug, um zu unserem ersten SCS Summit am 23. und 24. Mai 2023 in Berlin einzuladen, wo Anwender, Partner und Entwickler und jeder, der mit dem Projekt verbunden ist, Wissen und Erfahrungen austauschen und - natürlich - netzwerken und Spaß haben können.

## Gäste

<div class="row mb-5">
    <div class="col-sm-2">{% asset 'summit2023/default-avatar.jpg' class="img-fluid" style="width: 100%; max-height: 35vh; object-fit: cover; object-position: top;" %}</div>
    <div class="col-sm-10">
        <span class="fw-bold">Dr. Franziska Brantner</span><br />
        <span class="fw-light">Parlamentarische Staatssekretärin im Bundesministerium für Wirtschaft und Klimaschutz</span>
    </div>
</div>

<ul id="lightSlider">
{% for speaker in site.data.summit2023.speakers %}
  <li>
    <div>{% asset '{{speaker.avatar}}' class="img-fluid" style="width: 100%; height: 150px; object-fit: cover; object-position: top;" %}</div>
    <span class="fw-bold">{{speaker.name}}</span><br />
    <span class="fw-light" style="word-wrap: break-word;">{{speaker.title}}</span>
  </li>
{% endfor %}
</ul>

## Themen

What you can expect are exciting talks, discussions and workshops on the following topics:

* Die Bedeutung digitaler Souveränität für Wirtschaft, Staat und Gesellschaft in Europa
* Deutsche Verwaltungscloud-Strategie
* Use Cases mit SCS wie die Bayrische Schulcloud
* Warum SCS für die Innovationsfähigkeit in Europa wichtig ist
* Das SCS-Zertifizierungsprogramm und die ersten SCS-zertifizierten Clouds
* Der Wert von Standardisierung

## Veranstaltungsort

The SCS Summit will take place in the beautiful facilities of the Berlin-Brandenburg Academy of Sciences and Humanities (BBAW). 
Eine [ausführliche Wegbeschreibung](https://veranstaltungszentrum.bbaw.de/en/directions) finden Sie auf der offiziellen Seite der BBAW.

<div class="row align-items-center justify-content-center">
{% for i in (1..3) %}
	<div class="col-12 col-md-4 d-flex">
  	{% asset 'summit2023/bbaw-{{i}}.jpg' alt='BBAW' class='mx-auto d-block img-fluid my-3' %}
	</div>
{% endfor %}
</div>
<p class="text-end text-muted fw-light"><small>© Images by BBAW / Judith Affolter</small></p>

## Anmelden

<pretix-widget event="https://events.scs.community/scs-summit-2023"></pretix-widget>
<noscript>
   <div class="pretix-widget">
        <div class="pretix-widget-info-message">
            JavaScript ist in Ihrem Browser deaktiviert. Um unseren Ticketshop ohne JavaScript aufzurufen, klicken Sie bitte <a target="_blank" rel="noopener" href="https://events.scs.community/scs-summit-2023">hier</a>.
        </div>
    </div>
</noscript>

## Presse

Wir freuen uns darauf Presse und Medienpartner auf unserem SCS Summit zu begrüßen. Bitte melden Sie sich für eine Akkreditierung an [presse@osb-alliance.com](mailto:presse@osb-alliance.com). Gerne lassen wir Ihnen vorab eine ausführliche Pressemappe sowie die Möglichkeit auf Interviews zukommen.

## Sponsoren

<div class="row align-items-center justify-content-center mb-3">
    {% for sponsor in site.data.summit2023.sponsors.gold %}
	<div class="col-5 col-md-4 col-lg-3 p-3 d-flex justify-content-center">
        <a href="{{sponsor.url}}" title="{{sponsor.name}}" target="_blank">
            {% asset '{{sponsor.logo}}' alt='{{sponsor.name}}' class='mx-auto d-block img-fluid' style="width: 100%; max-height: 15vh; object-fit: contain;" %}
        </a>
	</div>
    {% endfor %}
</div>
<div class="row align-items-center justify-content-center">
    {% for sponsor in site.data.summit2023.sponsors.silver %}
	<div class="col-4 col-md-3 col-lg-2 p-{{sponsor.padding}} d-flex justify-content-center">
        <a href="{{sponsor.url}}" title="{{sponsor.name}}" target="_blank">
            {% asset '{{sponsor.logo}}' alt='{{sponsor.name}}' class='mx-auto d-block img-fluid' style="width: 100%; max-height: 15vh; object-fit: contain;" %}
        </a>
	</div>
    {% endfor %}
</div>

## Kontakt

Gerne helfen Ihnen [Bianca](https://scs.community/hollery) oder [Alexander](https://scs.community/diab) bei Ihren Fragen weiter. Wir freuen uns auf Sie in Berlin!

<div class="row justify-content-center my-4">
  <div class="col-6 col-md-4 col-lg-3 d-flex justify-content-center">
    <div class="card" style="width: 13rem;">
      {% asset 'employees/Hollery.jpg' class="card-img-top img-fluid" style="width: 100%; max-height: 35vh; object-fit: cover; object-position: top;" %}
      <div class="card-body">
        <p class="card-text"><a class="link-unstyled stretched-link fs-6" href="https://scs.community/hollery">Bianca Hollery-Pfister</a></p>
      </div>
    </div>
  </div>
  <div class="col-6 col-md-4 col-lg-3 d-flex justify-content-center">
    <div class="card" style="width: 13rem;">
      {% asset 'employees/Diab.jpg' class="card-img-top img-fluid" style="width: 100%; max-height: 35vh; object-fit: cover; object-position: top;" %}
      <div class="card-body">
        <p class="card-text"><a class="link-unstyled stretched-link fs-6" href="https://scs.community/diab">Alexander Diab</a></p>
      </div>
    </div>
  </div>
</div>
