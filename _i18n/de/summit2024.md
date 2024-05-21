# 2. Sovereign Cloud Stack Summit 14. Mai 2024 in Berlin


Liebe Freunde und Interessierte an SCS,

die SCS Community ist im vergangenen Jahr kräftig gewachsen, es sind viele neue Produktionsumgebungen auf Basis von SCS entstanden und am 20. März konnten wir planmäßig das 6. Release veröffentlichen.
Seien Sie in Berlin dabei, wenn SCS Nutzende aus verschiedensten Anwendungsfeldern ihre Erfahrungen teilen und berichten, warum sie sich für digital souveräne Cloud-Technologie mit SCS entschieden haben und erfahren Sie, wie die Zukunft des SCS Projektes aussehen wird.

Wir freuen uns besonders, dass unser Summit mit dem Auftakt der OpenInfra Day Roadshow kombiniert wird. Der [OpenInfra Day Germany 2024](https://oideurope2024.openinfra.dev/#registration=1) findet am Mittwoch, den 15. Mai 2024 in den gleichen Räumlichkeiten wie unser Summit statt. Nutzen Sie die einmalige Gelegenheit, am ersten Tag SCS, unsere Partner und unsere Community kennenzulernen, und am zweiten Tag in die Welt der Open-Source-Community-Arbeit einzutauchen.

Bitte beachten Sie, dass das Programm deutschsprachig sein wird. Einen detaillierten Zeitplan finden Sie weiter unten auf dieser Seite.

## DANKE!

Der 2. SCS Summit ist vorbei. Danke an alle, die dabei waren -  auf, vor und hinter der Bühne.

Wir haben gesehen, was gemeinsam schon erreicht wurde, was die Pläne für die Zukunft sind, und dass es immer mehr werden, die mithelfen, Digitale Souveränität zu verwirklichen!
Auf der Bühne wurde eindrucksvoll berichtet und diskutiert, welche Bedeutung digitale Souveränität für Freiheit, Demokratie, Handlungsfähigkeit, Innovationskraft und Krisenstabilität hat, wie digitale Souveränität konkret geschaffen wird und welche Rolle Open Source dabei spielt.

Für alle, die nicht dabei sein konnten oder die einen Vortrag gern noch einmal hören wollen, werden in Kürze hier die Videos und Präsentationen verfügbar sein.


## Veranstaltungsort

Der SCS Summit 2024 fand in der [Villa Elisabeth](https://www.elisabeth.berlin/de/kulturorte/villa-elisabeth), Invalidenstraße 3 in 10115 Berlin-Mitte, statt (Nähe S Nordbahnhof).

## Sprecherinnen und Sprecher

{% include summit2024/speakers.html %}

## Zeitplan

<div class="container my-4">
    <!-- Nav tabs -->
    <ul class="schedule-nav nav nav-pills nav-justified" id="schedule-tab" role="tablist">
        <li class="nav-item me-2">
            <a class="nav-link active" id="tab-day-1" data-bs-toggle="tab" href="#day-1" role="tab"
                aria-controls="day-1" aria-selected="true">
                <span class="meta d-none d-lg-block">Dienstag, 14. Mai</span>
            </a>
        </li>
    </ul>
    <!-- Tab panes -->
    <div class="schedule-tab-content tab-content mt-5">
        {% for i in (1..2) %}
        <div class="tab-pane fade {% if i == 1 %}show active{% endif %}" id="day-{{i}}" role="tabpanel"
            aria-labelledby="day-{{i}}">
            {% for talk in site.data.summit2024-talks %}
            {% if i == talk.day %}
            <div class="item item-talk">
                <div class="meta">
                    <h4 class="time">{{talk.start}} – {{talk.end}}</h4>
                    <!--//profile-->
                </div>
                <!--//meta-->
                <div class="content">
                    <h3 class="title mb-2">{{talk.title}}<a data-tab-destination="day-{{i}}"
                            href="#session-{{ forloop.index }}" class="link-unstyled"><i
                                class="fa fa-link ms-2 text-muted" aria-hidden="true" style="font-size: .7em;"></i></a>
                    </h3>
                    <div class="desc pb-2"><b>{{ talk.description }}</b></div>
                    {% if talk.description2 %}<div class="desc pb-2"><b>{{ talk.description2 }}</b></div>{% endif %}
                    {% if talk.description3 %}<div class="desc pb-2"><b>{{ talk.description3 }}</b></div>{% endif %}
                    {% if talk.description4 %}<div class="desc pb-2"><b>{{ talk.description4 }}</b></div>{% endif %}
                    {% if talk.description5 %}<div class="desc pb-2"><b>{{ talk.description5 }}</b></div>{% endif %}
                    <div class="desc pb-2"><i>{{ talk.abstract }}</i></div>
                    {% if talk.slides %}
                    <div class="desc pb-2"><a href="{{ talk.slides }}">Folien</a></div>
                    {% endif %}
                    {% if talk.video %}
                    <div class="desc pb-2"><a href="{{ talk.video }}">Video</a></div>
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


## Sponsoren

{% include summit2024/sponsors.html %}

## Kontakt

Bei Fragen helfen Ihnen [Regina](https://scs.community/metz) oder [Alexander](https://scs.community/diab) gern weiter.

{% include summit2024/contact.html %}
