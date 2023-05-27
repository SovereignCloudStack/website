# Sovereign Cloud Stack Summit 2023

Liebe Freunde und interessierte Beobachter von SCS,

der Sovereign Cloud Stack ist erfolgreich im zweiten Jahr angekommen und hat eine aktive Community etabliert, die einen standardisierten Open Source Cloud Computing Stack entwickelt und pflegt. Erfolg heißt, dass wir die vierte Version herausgebracht haben und ~~drei~~vier Public Cloud Service Provider ihr Angebot auf SCS Standards und Technologie bereitstellen. Grund genug, um zu unserem ersten SCS Summit am **23. und 24. Mai 2023 in Berlin** einzuladen, wo Anwender, Partner und Entwickler und jeder, der mit dem Projekt verbunden ist, Wissen und Erfahrungen austauschen und - natürlich - netzwerken und Spaß haben können.

## Danke!

Die Veranstaltung ist jetzt vorbei. Wir hatten sehr interessante Vorträge und Podiumsdiskussionen auf der Bühne und wirklich gute Gespräche mit allen Teilnehmenden. Danke an alle, die teilgenommen haben, insbesondere natürlich an die Sprecherinnen und Sprecher und an die Organisatorinnen und Organisatoren.

Diese Seite bleibt bestehen, um die Veranstaltung zu dokumentieren und enthält die gesammelten Links zu den Folien und den Videos.

## Sprecherinnen und Sprecher

{% include summit2023/speakers.html %}

## Zeitplan

<div class="container my-4">
    <!-- Nav tabs -->
    <ul class="schedule-nav nav nav-pills nav-justified" id="schedule-tab" role="tablist">
        <li class="nav-item me-2">
            <a class="nav-link active" id="tab-day-1" data-bs-toggle="tab" href="#day-1" role="tab"
                aria-controls="day-1" aria-selected="true">
                <span class="heading">Tag 1</span>
                <span class="meta d-none d-lg-block">(Dienstag, 23. Mai)</span>
            </a>
        </li>
        <li class="nav-item me-2">
            <a class="nav-link" id="tab-day-2" data-bs-toggle="tab" href="#day-2" role="tab" aria-controls="day-2"
                aria-selected="false">
                <span class="heading">Tag 2</span>
                <span class="meta d-none d-lg-block">(Mittwoch, 24. Mai)</span>
            </a>
        </li>
    </ul>
    <!-- Tab panes -->
    <div class="schedule-tab-content tab-content mt-5">
        {% for i in (1..2) %}
        <div class="tab-pane fade {% if i == 1 %}show active{% endif %}" id="day-{{i}}" role="tabpanel"
            aria-labelledby="day-{{i}}">
            {% for talk in site.data.summit2023-talks %}
            {% if i == talk.day %}
            <div class="item item-talk">
                <div class="meta">
                    <h4 class="time">{{talk.start}} – {{talk.end}}</h4>
                    <div class="profile mt-3">
                        <div class="d-flex justify-content-center">{% assign post = talk %}{% include news/blog_avatars.html %}</div>
                        <div class="name mt-2">
                        {{talk.speaker | join: ", "}}
                        </div>
                    </div>
                    <!--//profile-->
                </div>
                <!--//meta-->
                <div class="content">
                    <h3 class="title mb-2">{{talk.title}}<a data-tab-destination="day-{{i}}"
                            href="#session-{{ forloop.index }}" class="link-unstyled"><i
                                class="fa fa-link ms-2 text-muted" aria-hidden="true" style="font-size: .7em;"></i></a>
                    </h3>
                    <div class="location mb-2 text-muted"><i class="fa fa-map-marker me-2"
                            aria-hidden="true"></i>{{talk.location}}</div>
                    <div class="desc pb-2">{{talk.description}}</div>
                    {% if talk.slides %}
			<div class="desc pb-2"><a href={{talk.slides}} alt="Link zu den Folien">Folien</a></div>
		    {% endif %}
                    {% if talk.video %}
			<div class="desc pb-2"><a href={{talk.video}} alt="Link zum Vortragsvideo">Video</a></div>
		    {% endif %}
                </div>
                <!--//content-->
            </div>
            {% endif %}
            {% endfor %}
        </div>
        {% endfor %}
    </div>
</div>

## Veranstaltungsort

Der SCS Summit fand in den wunderschönen Räumlichkeiten der Berlin-Brandenburgischen Akademie der Wissenschaften (BBAW) statt.
Eine [ausführliche Wegbeschreibung](https://veranstaltungszentrum.bbaw.de/en/directions) finden Sie auf der offiziellen Seite der BBAW.

{% include summit2023/bbaw.html %}

## Sponsoren

{% include summit2023/sponsors.html %}

## Kontakt

Gerne helfen Ihnen [Bianca](https://scs.community/hollery) oder [Alexander](https://scs.community/diab) bei Ihren Fragen weiter. Wir freuen uns auf Sie in Berlin!

{% include summit2023/contact.html %}
