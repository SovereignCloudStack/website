# Sovereign Cloud Stack nutzen

## Wie man SCS bekommt

Sovereign Cloud Stack ist vollständig Open Source -- wir entwickeln
es in einem offenen Entwicklungsprozess in einer offenen Community.
Wir folgen den
[Four Opens](https://openinfra.dev/four-opens/) der Open Infrastructure
Community. Wir arbeiten eng mit den upstream Projekten der
[Open Infrastructure Foundation](https://openinfra.dev/), der
[Cloud Native Computing Foundation](https://cncf.io/) und weiteren
zusammen. Der größte Teil unseres Quellcodes kommt aus diesen
Communities -- wenn wir diese verbessern, ergänzen, Dinge
ändern, dann suchen wir den Kontakt mit ihnen, so dass wir
unsere Änderungen wieder zurückgeben und einfließen lassen können.

Wir nutzen [github/SovereignCloudStack](https://github.com/SovereignCloudStack/) um
den von uns genutzten Code zu verwalten -- unser eigener Code
besteht hauptsächlich aus der Automatisierung und der
Integration der die genutzten Upstream Projekte in einer
konsistenten und gut zu verwaltenden Art verbindet.
Dazu kommen Dokumentation und natürlich eine Menge
von kontinuierlichen Integrationstests (CI).

Um den SCS Code zu installieren, um ihn zu studieren, zu testen,
zu verändern und auch um zu ihm beitragen zu können verweisen wir
auf unser
[github SCS Docs](https://github.com/SovereignCloudStack/Docs/)
Repository.

Am 15.7.2021 haben wir [Release 0](https://github.com/SovereignCloudStack/release-notes/blob/main/Release0.md) freigegeben.

Am 29.9.2021 haben wir [Release 1](https://github.com/SovereignCloudStack/release-notes/blob/main/Release1.md) freigegeben.

Am 23.3.2022 haben wir [Release 2](https://github.com/SovereignCloudStack/release-notes/blob/main/Release2.md) freigegeben.

Am 21.9.2022 haben wir [Release 3](https://github.com/SovereignCloudStack/release-notes/blob/main/Release3.md) freigegeben.

Am 22.3.2023 haben wir [Release 4](https://github.com/SovereignCloudStack/release-notes/blob/main/Release4.md) freigegeben.

## SCS und OSISM

Für die grundlegenden Schichten bauen wir auf dem
[Open Source Infrastructure and Service Manager](https://osism.tech/) (OSISM)
Projekt auf.

## Beitragen

Informationen rund um unsere alltägliche Zusammenarbeit sind auf
der Seite ["Zu SCS beitragen"](https://scs.community/de/contribute/) zusammengefasst.

Wir haben einen
[contributor guide](https://scs.community/docs/contributor/)
geschrieben, welcher einige der Prozesse und Regeln, die wir
zu nutzen entschieden haben, dokumentiert.

Wenn man mitmachen möchte, schlagen wir vor, mit uns
[in Kontakt zu treten](mailto:project@scs.sovereignit.de).
Wir würden dann eine kurze Onboarding-Sitzung machen und
zu den virtuellen wöchentlichen Team Meetings einladen.

Wir freuen uns auch über gelegentliche Beiträge -- das kann
über Issues oder besser PRs auf github geschehen.
Bei letzterem sollte an den DCO (Signed-off-by:) gedacht werden,
damit wir den Beitrag auch in rechtlich sicherer Weise nutzen.

Wir sind eine offene Community, die Neuankömmlinge willkommen heisst.
Unsere Erwartungen an das Verhalten der Beitragenden haben wir in einem
[Verhaltenskodex](https://github.com/SovereignCloudStack/.github/blob/main/CODE_OF_CONDUCT.md)
zum Ausdruck gebracht.

## SCS einsetzen

Man kann verschiedene Schritte machen, um SCS zu unterstützen und einzusetzen.

Zunächst einmal freuen wir uns über Beiträge an SCS und den relevanten
upstream Open Source Projekten. Wenn wir uns gemeinsam für Themen
einsetzen um z.B. erfolgreich die digitale Souveränität voranzubringen,
so finden wir das ausgezeichnet.

Bei der Umsetzung von SCS kann man in zwei Richtungen denken:
Welche Module von SCS und welches Niveau der Umsetzung.

Zum einen ist SCS modular. Man kann z.B. einfach nur Teile des Container
Stacks einsetzen. Oder vielleicht den ganzen Stack an Betriebswerkzeugen.
Oder den IaaS Teil. Oder ceph. Oder alles außer ceph ...

Desweiteren gibt es zwei verschiedene Stufen der Umsetzung.

### Stufen der Umsetzung

Die erste Stufe wäre, die Plattform (oder genauer das Modul) mit den
SCS Standards kompatibel zu machen. Das stellt sicher, dass man mit
einem wachsenden Ökosystem kompatibel ist. Dafür müssen Kompatilibtätstests
bestanden werden. (Die Tests müssen Stand Juli 2021 großteils noch entwickelt
werdne. Das wird aber passieren, da es ein grundlegender Baustein unseres
Projekts ist.)

Die zweite Stufe wäre die Benutzung der (Referenz)Implementierung für
das fragliche Modul. Das bedeutet, dass man das gleiche Stück Code
nutzt und zu ihm beiträgt wie die anderen Partner und dadurch eine Menge
Arbeit bei der Auswahl, Integration, Automatisierung, Validierung,
Dokumentation dieses Teils spart. Da wir auch Best Practices für
den Betrieb definieren und Umsetzen, eröffnet das auch die Möglichkeit
eines Effizienzgewinns im Betrieb -- bis hin zur Möglichkeit, betriebliche
Aufgaben über die einzelne Plattform hinweg gemeinsam wahrzunehmen
in einer Art OpenOperations Modell.

Eine Umsetzungsmatrix könnte (stark vereinfacht) wir folgt aussehen:

<div class="table-responsive" markdown="1">

| Modul        | Umsetzungstufe 2021 | Umsetzungsstufe 2022 |
|--------------|:-------------------:|:--------------------:|
| Monitoring   |     nicht           |  kompatibel          |
| IaaS         |     kompatibel      |  Implementierung     |
| Storage      |     nicht           |  nicht               |
| k8s-capi     |     Implementierung |  Implementierung     |
| k8s registry |     Implementierung |  Implementierung     |

</div>
