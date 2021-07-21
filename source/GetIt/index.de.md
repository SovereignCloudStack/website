# Sovereign Cloud Stack nutzen

## Wie man SCS bekommt

Sovereign Cloud Stack ist vollständig Open Source -- wir entwickeln
es in einem offenen Entwicklungsprozess in einer offenen Community.
Wir folgen den
[Four Opens](https://openinfra.dev/four-opens/) der Open Infrastructure
Community. Wir arbeiten eng mit den upstream Projekten der
[Open Infrastructure Foundation](https://openinfra.dev/),der 
[Cloud Native Compute Foundation](https://cncf.io/) und weiteren
zusammen. Der größte Teil unseres Quellcodes kommt aus diesen
Communities -- wenn wir diese verbessern, ergänzen, Dinge
ändern, dann suchen wir den Kontakt mit ihnen, so dass wir
unsere Änderungen wieder zurückgeben und einfließen lassen können.

Wir nutzen [github](https://github.com/SovereignCloudStack/) um
den von unse genutzten Code zu verwalten -- unser eigener Code
besteht hauptsächlich aus der Automatisierung und der
Integration der die genutzten Upstream Projekte in einer
konsistenten und gut zu verwaltenden Art verbindet.
Dazu kommmen von Dokumentaiton und natürlich eine Menge
von kontinuierlichen Integrationstests (CI).

Um den SCS Code zu installieren, um in zu studieren, zu testen,
zu verändern und auch zu ihm beitragen zu können verweisen wir
auf unser
[github Docs](https://github.com/SovereignCloudStack/Docs/)
repository.

Am 15.7.2021 haben wir [Release 0](/News/release0.html.de) freigegeben.

## SCS und OSISM

Für die grundlegenden Schichten bauen wir auf dem
[Open Source Infrastructure and Service Manager](https://osism.tech/) (OSISM)
Projekt auf.

## Beitragen

Wir haben einen
[contributor guide](https://scs.community/docs/contributor/)
geschrieben, welcher einige der Prozesse und Regeln, die wir
zu nutzen entschieden haben, dokumentiert.

Wenn man mitmachen möchte, schlagen wir vor, mit uns
[in Kontakt zu treten](mailto:project@scs.sovereignit.de).
Wir würden dann eine kurze onboarding Sitzung machen und
zu den virtuellen wöchentlichen Team Meetings einladen.

Wir freuen uns auch über gelegentliche Beiträge -- das kann
über issues oder besser PRs auf github geschehen.
Bei letzterem sollte an den DCO (Signed-off-by:) gedacht werden,
damit wir den Beitrag auch in rechtlich sicherer Weise nutzen

## SCS umsetzen

Man kann verschiedene Schritte machen, um SCS zu unterstützen und umszusetzen.

Zunächst einmal freuen wir uns über Beiträge an SCS und den relevanten
upstream Open Source Projekten. Wenn wir uns gemeinsam für Themen
einsetzen um z.B. erfolgreich die digitale Souveränität voranzubringen,
so finden wir das ausgezeichnet.

Bei der Umsetzung von SCS kann man in zwei Richtungen denken:
Welche Module von SCS und welches Niveau der Umsetzung.

Erstens ist SCS modular. Man kann z.B. einfach nur Teile des Container
Stacks einsetzen. Oder vielleicht den ganzen Stack an Betriebswerkzeugen.
Oder den IaaS Teil. Oder ceph. Oder alles außer ceph ...

Bei Niveau der Umsetzung sehen wir zwei Möglichkeiten.

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

| Modul        | Umsetzungstufe 2021 | Umsetzungsstufe 2022 |
|--------------|:-------------------:|:--------------------:|
| Monitoring   |     nicht           |  kompatibel          |
| IaaS         |     kompatibel      |  Implementierung     |
| Storage      |     nicht           |  nicht               |
| k8s-capi     |     Implementierung |  Implementierung     |
| k8s registry |     Implementierung |  Implementierung     |
