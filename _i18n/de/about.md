# Über Sovereign Cloud Stack

Sovereign Cloud Stack (SCS) ist ein Netzwerk existierender und angehender
Anbieter von standardisierter souveräner Cloud und Container Infrastruktur
mit dem Ziel, gemeinsam die Definition, Implementation und den Betrieb
einer vollständig offenen, föderierten und kompatiblen Plattform voranzubringen.
Durch die Zusammenarbeit unterstützt die Plattform ein gesundes Ökosystem
für Entwicklungs/Betriebsteams (DevOps Teams) von Software und stärkt
somit den Fortschritt bei der Digitalisierung in Europa, ohne dabei größere
Risiken von Kontrollverlust über Technologie und Daten mit sich zu bringen.

## Ziele

### Zertifizierbare Standards

Wir zielen darauf ab, Standards zu definieren, die präzise genug festgelegt
sind, dass Software, die für eine SCS Implementierung gebaut und getestet
wurde, ohne zusätzlichen Aufwand auf anderen SCS-basierten Infrastruktur
funktioniert. Unsere Standards sind eine Sammlung von Upstream Standards,
ggf. um spezielle Details angereichert, dort wo die Upstream Spezifikationen
Lücken aufweisen. Wir arbeiten an Conformance Tests, so dass Änderungen im
Hinblick auf ihre Standardkonformität bewertet werden können.

Zertifizierbare Standards sind eine Voraussetzung, um ein lebendiges
Ökosystem oberhalb von SCS etablieren zu können.

Wir arbeiten auch an (optionalen) Standards zu betrieblichen Themen.
Transparenz über Monitoring und Wurzel-des-Übels Analysen (Root-Cause-Analysis)
bei Zwischenfällen nützen unmittelbar dem Kunden. Betreibern hilft
es, insbesondere beim betrieblichen Teil von DevOps am gemeinsam aufgebauten
Wissen teilhaben zu können und macht Betrieb effizienter; auch bei der Suche
nach geeignetem Personal helfen gemeinsame Standards.

Qualitäts- und Sicherheitstests sind Teil der Standardtestprozeduren.
Die Einhaltung von z.B. Sicherheitsstandards kann so auch kontinuierlich
sichergestellt werden.

### Offenheit und Transparenz

Die gesamte Software ist vollständig open source -- wir halten nichts von
open core Modellen. Es geht aber nicht nur um die Software Lizenz: SCS
wird in einem offenen Entwicklungsprozess erstellt, mit offenen 
Entwurfsprozessen und -entscheidungen durch eine offene Gemeinschaft. 
Das stellt sicher, dass die Software auch wirklich von den Nutzern genutzt 
und beeinflusst werden kann. Somit wird die Freiheit der Nutzer sichergestellt.

Die Transparenz des Codes und des Entwicklungsprozesses ist eine wichtige
Eigenschaft, um sicherzustellen, dass dem Code vertraut werden kann.

### Nachhaltigkeit

Die IT Welt ist schnelllebig. Neue Technologien ersetzen alte sehr schnell.
Mit dem Sovereign Cloud Stack haben wir an der Basis relativ stabile
Softwareinfrastruktur, während wir die schnellen Wechsel auf den Schichten
darüber erleichtern. Eine relativ langlebige Basisschicht vermeidet die
Notwendigkeit, dass Betreiber ständig diese neu bauen müssen.

Das schafft auch den Raum, an Nachhaltigkeit bzgl. des Energiebedarfs
zu arbeiten. Die Automatisierung von verbrauchsoptimierten
Platzierungsentscheidungen und die Nutzung von Stromsparmechanismen
sind in SCS wichtige Themen.

### Föderierung

In unserer Vision wird die zentralisierte Kontrolle über Infrastruktur
durch ein Netzwerk kollaborierender Anbieter ersetzt. Die hochgradig
zueinander kompatiblen SCS Clouds, gute Netzwerkverbindungen sowie
eine föderierbare Identitäts- und Zugriffsverwaltung bringen uns einer
großen globalen virtuellen Cloud näher, ohne dass es einer zentralen
Kontrollinstanz bedürfte.

## Vorteile ...

### ... für DevOps teams (PaaS/SaaS Entwicklung/Betrieb)

Eine wohl-definierte Umgebung, welche sowohl als kleine private
Umgebung oder ebenso als große öffentliche Cloud zur Verfügung steht
vermeidet doppelte Arbeit bei Implementierung und Validierung.
SCS ist somit eine attraktive Zielplattform.

### ... für Public Cloud Anbieter

Durch die Erfüllung von SCS Standards und der Teilnahme im SCS Ökosystem
ist eine viel größere Menge an Anwendungen und DevOps Team verfügbar,
welche auf dieser Plattform arbeiten. Der adressierbare Markt wächst
somit deutlich.

Der Schritt von bloßer Standardkonformität hin zur Nutzung von einigen
oder auch allen SCS Modulen der Referenzimplementierung erspart eine
Menge doppelter Arbeit -- bei der Auswahl, der Integration, der
Automatisierung, der Konfiguration, dem Testen, dem Dokumentieren der
Software und beim Aufbau der Betriebsprozesse, der Überwachung,
dem Update, ... um diese Umgebung in Betrieb zu halten.

Nicht zuletzt kann der Betrieb so auch einfacher mit anderen
gemeinsam verrichtet werden oder gar komplett outgesourct werden.
Qualifiziertes Personal ist in jedem Falle eher erhältlich.

### ... für die Gesellschaft

Die Nutzung moderner IT Infrastruktur mit voller Automatisierung
zur Installation und der Verwaltung des gesamten Lebenszyklus
(=Infrastructure as Code, IaC) liefert einen enormen Fortschritt
bei der Produktivität von DevOps Teams. Europa braucht solche
Fortschritte dringend, um zu vermeiden, (weiter) zurückzufallen
im globalen Wettbewerb, in dem zunehmend traditionelle Industrie
durch digitale Innovation disruptiert wird.

Sich dabei einfach auf die Hyperscaler zu verlassen bringt
leider viele Nachteile mit sich:

* Diese passen gar nicht immer zum Nutzungsszenario; insbesondere
  wenn dezentrale IT Infrastruktur (edge) vonnöten ist.

* Sie bringt rechtliche Probleme mit sich, in Hinblick auf
  die Verordnungen des Datenschutzes (und manchmal auch der Sicherheit).

* Sie führt zu strategischen Abhängigkeit von einem oder einer
  kleiner Zahl von großen Unternehmen,

* Sie führt zu ökonomischen Abhängigeiten.

All diese Probleme sind Hemmnisse bei der Umstellung auf die
Nutzung der Clouds der Hyperscaler.

Die Auswahl zwischen lokalen SCS Cloudanbietern oder gar der
Implementation einer eigenen privaten Cloud (gleicher Technologie)
zu haben ermöglicht es, die Vorteile moderner IaC Infrastruktur
zu nutzen ohne obige Nachteile in Kauf nehmen zu müssen.

Aus geopolitischer Sicht ist zu beobachten, dass ein zunehmender
Teil der Wertschöpfung in den zunehmend digitalisierten
Wertschöpfungsketten stattfindet -- zu unterstützen, dass ein
wachsender Teil davon in Europa stattfinden kann verringert
die strategischen Risiken und sorgt für einen höheren Wertbeitrag
Europas.

## Deployment Modelle

Standardmäßig ist SCS für kleine (ein halber Schrank Hardware) bis
große Clouds (Hunderte von Servern je Region) optimiert -- vom
Rechenzentrum bis hin zu Near Edge Szenarien.

Die Cloud kann als Private Cloud durch eine gut ausgebildete
IT Abteilung bereitgestellt werden oder auch als Public Cloud
durch einen Cloud Provider. Wir vernetzen beide Gruppen.

We haben arbeiten an Plänen für optimierte Szenarien für
far-edge Clouds in einem Folgeprojekt ("SCS-2").

## Sovereign Cloud Stack und Gaia-X

Digitale Souveräntiät ist ein Kernziel von [Gaia-X](https://gaia-x.eu/).
Wir sind der Ansicht, dass viele Szenarien, welche den souveränen
Umgang mit Daten benötigen, dies nicht gut erreichen können ohne
Kontrolle über die Infrastruktur zu haben.

SCS möchte es (potentiellen) Anbietern von Infrastruktur sehr viel
einfacher machen, souveräne Angebot zu machen. Daher ist SCS Teil
des Gaia-X Projekts geworden. Ursprünglich war SCS als Unterarbeitsgruppe
in der AG Software und Architektur im Workstream 2 -- mittlerweile ist
SCS als (Offenes) Arbeitspaket verfasst, welche an die Provider
Arbeitsgruppe des Technical Committees der Gaia-X AISBL andockt.

SCS Mitarbeitende unterstützen viele Projekte in Gaia-X, wie
z.B. die Federation Services / Open Source Software Arbeitsgruppe,
die Infrastruktur Unterarbeitsgruppe, das Architecture of Standards
Arbeitspaket, das Product & Service Board, die Minimal Viable
Gaia-X Pilotierungsgruppe, das Selbstbeschreibungsarbeitspaket,
und die Cross-Environment Service Orchestration Gruppe.

Es gibt eine enge Verbindung mit den Arbeiten zu den
Gaia-X Federation Services ([GXFS](https://gxfs.de/)).
Es gibt die gemeinsame Vorstellung, SCS Infrastruktur mit den GXFS
darauf als Plattform für souveräne Datendienste zu liefern.
SCS Partner unterstützen GXFS mit Infrastruktur für Entwicklungs-
und Testzwecke.

## Projekt und Finanzierung

Das SCS Projekt wurde von Freiwilligen initiiert.
Mit der nun gewährten Förderung wird das Projekt von der
[OSB Alliance](https://osb-alliance.de/) beherbergt.
Sie hat ein kleines wachsendes zentrales Team eingestellt, um 
das Projekt zu steuern und zu koordinieren.

Um das zentrale Team hat sich eine wachsende Community von Freiwilligen
gebildet, welche am Projekt mitarbeitet.

Mit der verfügbaren Förderung kann nun auch freie Softwareentwicklung
bezahlt werden, die einzelnen Unternehmen nicht genügend Nutzen bringt,
um aus Eigenantrieb stattzufinden. Die Arbeitspakete / Lose dafür werden
öffentlich ausgeschrieben.

## Technologische Vision

Die Automatisierung der Verwaltung des Lebenszyklus aller Komponenten
ist der Schlüssel: Grundlegende Infrastrukturdienste wie Datenbank,
Message Dienst, ..., die Betriebswerkzeuge (Monitoring, Logging, Patching,
Nutzungserfassung, ...), Nutzerverwaltung (LDAP, Keycloak, ...),
die grundlegende Virtualisierung (KVM, ceph, OVN), die IaaS Schicht
(Kerndienste von OpenStack) und die Werkzeuge rund um Kubernetes werden
hier alle abgedeckt. Die Dienste werden durch Ansible als Container
augebracht. Auf dieser Schicht werden Docker/Podman Container benutzt.
Hierdurch wird die Platzierung ... explizit
festgelegt -- wir sehen die von k8s erzeugte hohe Dynamik auf dieser
Schicht nicht als Vorteil. Dies ist auf höheren Schichten natürlich
anders, in Abhängigkeit der Nutzerbedürfnisse.

<figure class="figure mx-auto d-block" style="width:90%">
  <a href="{{ "/assets/images/201001-SCS-4a.png" | prepend: site.baseurl_root }}">
    <img src="{{ "/assets/images/201001-SCS-4a.png" | prepend: site.baseurl_root }}" class="figure-img w-100">
  </a>
  <figcaption class="figure-caption">
    Das Bild zeigt die Architektur und einige Komponenten von SCS.
  </figcaption>
</figure>

Die Kerndienste von OpenStack dienen hauptsächlich als starke
mandantenfähige Basis, um viele k8s Cluster zu verwalten.
Der Hauptdienst für Nutzer ist K8s as a Service -- dafür stellt
SCS die k8s Cluster API bereit. Anbieter können die Schnittstellen
natürlich auch nutzen, um den Endkunden einen Managed Service anzubieten.
Aus SCS Standardisierungssicht ist es optional, die OpenStack Schnittstellen
nach außen sichtbar zu machen; wenn es getan wird, gibt es von SCS Seite
dafür aber auch Standards, so dass auch auf dieser Ebene eine
Standardkonformität und Kompatibilität erreicht werden kann.

<figure class="figure mx-auto d-block" style="width:90%">
  <a href="{{ "/assets/images/Ecosys-SCS-Acatech.png" | prepend: site.baseurl_root }}">
    <img src="{{ "/assets/images/Ecosys-SCS-Acatech.png" | prepend: site.baseurl_root }}" class="figure-img w-100">
  </a>
  <figcaption class="figure-caption">
    Diese Zeichnung zeigt ein IT Ökosystem mit vier Cloudanbietern;
    zwei davon nutzen SCS Standards. Die Containerschicht kann über diese
    beiden Anbieter hinweg verwaltet werden.
    Für die Verwaltung auch über Hyperscaler oder andere inkompatible
    Angebote hinweg kann dann Software wie Gardener zum Einsatz gebracht
    werden. Diese wird auch auf SCS ständig validiert. Das Bild wurde anlässlich der Arbeit mit 
    <a href="https://www.acatech.de/">Acatech</a> beim Erstellen der
    <a href="https://www.acatech.de/publikation/digitale-souveraenitaet-status-quo-und-handlungsfelder/">Publikation zu digitaler Souveränität</a> gezeichnet.
    Die erste Ausgabe enthält noch eine ältere Version des Bildes.
  </figcaption>
</figure>

Es sollte zur Kenntnis genommen werden, dass die Technologiewahl
jenseits der mit (S) gekennzeichneten vorgeschriebenen Standards
an einigen Stellen noch vorläufig sein kann. Die Plattformdienste
werden als Teil des grundlegenden SCS ("SCS-1") Projekts noch
nicht standardisiert. Dies ist Teil eines weitergehenden Plans ("SCS-3")
welcher sich in Arbeit befindet.

## SCS nutzen und mitmachen

Siehe Seite [SCS nutzen]({{ site.baseurl }}/use/).