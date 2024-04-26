# 2. Sovereign Cloud Stack Summit 14. Mai 2024 in Berlin


Liebe Freunde und Interessierte an SCS,

die SCS Community ist im vergangenen Jahr kräftig gewachsen, es sind viele neue Produktionsumgebungen auf Basis von SCS entstanden und am 20. März konnten wir planmäßig das 6. Release veröffentlichen.
Seien Sie in Berlin dabei, wenn SCS Nutzende aus verschiedensten Anwendungsfeldern ihre Erfahrungen teilen und berichten, warum sie sich für digital souveräne Cloud-Technologie mit SCS entschieden haben und erfahren Sie, wie die Zukunft des SCS Projektes aussehen wird.

Registrieren Sie sich [hier](https://events.scs.community/scs-summit-2024/)

und freuen Sie sich mit uns auf spannende Vorträge und Diskussionen:

* Der Leiter des Referats für Digitalisierung und Industrie 4.0 im Bundesministerium für Wirtschaft und Klimaschutz, Ernst Stöckl-Pukall, wird die Veranstaltung mit einem Grußwort eröffnen.
* Ann Cathrin Riedel, Geschäftsführerin von NExT e.V. und Mitglied des Digitalbeirats des Bundesministeriums für Digitales und Verkehr, wird in einer Keynote die Bedeutung von offenen und digital souveränen Infrastrukturen für Freiheit und Demokratie herausarbeiten.
* Einige unserer größten Partner und Cloud Service Provider werden darüber sprechen, warum sie sich für SCS als Technologie entschieden haben - und welche Rolle die Themen Implementierung und Zertifizierung dabei gespielt haben. Hier freuen wir uns auf Impulse unter anderem von Christian Schmitz, Director Open Source bei der Plusserver GmbH, und von Jens Plogsties, CTO der Syseleven GmbH.
* Wir stellen das bis dato größte SCS-Anwendungsprojekt und eines der größten Europäischen Cloudprojekte überhaupt vor. Über 1.000.000 named user, über 3.000 Namespaces, über 100 Cluster, 3 Data Center.
* Viola Heeger vom Tagesspiegel wird mit Ulrich Ahle, CEO von Gaia-X, und Jörg Kremer, Leiter Föderales IT-Architekturmanagement der FITKO, über die Bedeutung von Standards und standardisierter Technologie für die Föderierbarkeit von Digitalisierungsprojekten in öffentlicher Verwaltung und Privatwirtschaft in einem Europäischen Kontext diskutieren.
* Dirk Schrödter, Minister für Digitalisierung und Chef der Staatskanzlei des Landes Schleswig-Holstein, wird erläutern, warum im nördlichsten Bundesland "Open Souce First" gilt und SCS Grundlage für Cloudanwendungen, wie z.B. beim Call for Concepts zum Landesprogramm Offene Innovationen (DigitalHub.SH), ist.
* Die Product Owner von SCS werden verschiedene technische Aspekte und Komponenten von SCS vorstellen und erklären.
* Schließlich wird der Vorstandsvorsitzende der OSB Alliance und CEO der Univention GmbH, Peter Ganten, einen Ausblick zur Zukunft von SCS geben.


Wir freuen uns besonders, dass unser Summit mit dem Auftakt der OpenInfra Day Roadshow kombiniert wird. Der [OpenInfra Day Germany 2024](https://oideurope2024.openinfra.dev/#registration=1) findet am Mittwoch, den 15. Mai 2024 in den gleichen Räumlichkeiten wie unser Summit statt. Nutzen Sie die einmalige Gelegenheit, am ersten Tag SCS, unsere Partner und unsere Community kennenzulernen, und am zweiten Tag in die Welt der Open-Source-Community-Arbeit einzutauchen.

Das Programm des Summits wird im Laufe der nächsten Wochen immer weiter aktualisiert, besuchen Sie also regelmäßig unsere Website oder abonnieren Sie unseren [Community Digest](https://scs.sovereignit.de/mailman3/postorius/lists/announce.lists.scs.community/), um sich auf dem Laufenden zu halten.
Bitte beachten Sie, dass das Programm deutschsprachig sein wird.

## Zeitplan

<div class="container my-4">
    <!-- Nav tabs -->
    <ul class="schedule-nav nav nav-pills nav-justified" id="schedule-tab" role="tablist">
        <li class="nav-item me-2">
            <a class="nav-link active" id="tab-day-1" data-bs-toggle="tab" href="#day-1" role="tab"
                aria-controls="day-1" aria-selected="true">
                <span class="heading">Tag 1</span>
                <span class="meta d-none d-lg-block">(Dienstag, 14. Mai)</span>
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
                    <div class="desc pb-2">{{talk.abstract}}</div>
                    {% if talk.slides %}
			<div class="desc pb-2"><a href="{{talk.slides}}">Folien</a></div>
		    {% endif %}
                    {% if talk.video %}
			<div class="desc pb-2"><a href="{{talk.video}}">Video</a></div>
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

Der SCS Summit 2024 findet in Berlin-Mitte in der [Villa Elisabeth](https://www.elisabeth.berlin/de/kulturorte/villa-elisabeth) statt (Nähe S Nordbahnhof).

## Kontakt

Bei Fragen helfen Ihnen [Regina](https://scs.community/metz) oder [Alexander](https://scs.community/diab) gern weiter.

{% include summit2024/contact.html %}
