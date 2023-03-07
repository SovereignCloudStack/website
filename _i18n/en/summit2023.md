# Sovereign Cloud Stack Summit 2023

Dear Friends of SCS and interested Observers,

the Sovereign Cloud Stack is now in its second year successfully building a community to develop and maintain a standardized open source cloud computing stack. Success means that we have released the fourth version and that by now three cloud service providers base their offering on SCS standards and technology. Reason enough to call for our first summit on 23rd and 24th of May 2023 in Berlin for users, developers, adopters and everybody, who is affiliated to this project to gather, share knowledge, as well as experience and to – of course – network and have fun.

## Speakers

<div class="row mb-5">
    <div class="col-sm-2">{% asset 'summit2023/speaker/pressefoto-brantner.png' class="img-fluid" style="width: 100%; max-height: 35vh; object-fit: cover; object-position: top;" %}
    <p class="text-end text-muted fw-light"><small>© Edith Forster</small></p>
    </div>
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

## Topics

What you can expect are exciting talks, discussions and workshops on the following topics:

* The importance of digital sovereignty for economy, state and society in Europe
* Deutsche Verwaltungscloud-Strategie
* Use cases for SCS such as the Bavarian School Cloud
* Why SCS is important for innovation in Europe
* The SCS certification program and the first SCS-certified clouds
* Creating genuine added value with standardization

## Location

The SCS Summit will take place in the beautiful facilities of the Berlin-Brandenburg Academy of Sciences and Humanities (BBAW). You can find [detailed directions on the official BBAW website](https://veranstaltungszentrum.bbaw.de/en/directions).

<div class="row align-items-center justify-content-center">
{% for i in (1..3) %}
	<div class="col-12 col-md-4 d-flex">
  	{% asset 'summit2023/bbaw-{{i}}.jpg' alt='BBAW' class='mx-auto d-block img-fluid my-3' %}
	</div>
{% endfor %}
</div>
<p class="text-end text-muted fw-light"><small>© Images by BBAW / Judith Affolter</small></p>

## Register

<pretix-widget event="https://events.scs.community/scs-summit-2023"></pretix-widget>
<noscript>
   <div class="pretix-widget">
        <div class="pretix-widget-info-message">
            JavaScript is disabled in your browser. To access our ticket shop without JavaScript, please <a target="_blank" rel="noopener" href="https://events.scs.community/scs-summit-2023">click here</a>.
        </div>
    </div>
</noscript>

## Press

We look forward to welcoming press and media partners to our SCS Summit. For accreditation, please contact [presse@osb-alliance.com](mailto:presse@osb-alliance.com). We will be happy to send you a detailed press kit and the opportunity for interviews in advance.

## Sponsors

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

## Contact us

If you need any further information, please contact [Bianca](https://scs.community/hollery) or [Alexander](https://scs.community/diab) – they’ll be happy to help you. See you in Berlin!

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
