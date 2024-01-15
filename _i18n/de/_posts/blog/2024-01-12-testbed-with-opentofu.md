
[OSISM](https://osism.github.io/) ist als Referenzimplementierung für die Infrastructure-as-a-Service-Schicht im Projekt Sovereign Cloud Stack (SCS) bekannt.
Das [OSISM Testbed](https://github.com/osism/testbed) wird daher im SCS-Projekt verwendet, um die Infrastructure-as-a-Service-Schicht zu demonstrieren, zu testen und weiterzuentwickeln.

Die Entwicklung von OSISM und SCS bringt aufgrund ihres verteilten Charakters der Systemachitektur eine Vielzahl von Herausforderungen mit sich,
die sich auf verschiedene Ebenen erstrecken können. Neben dem rein funktionalen Testen von Infrastrukturkomponenten, wie es z.B. mit
[Cloud in a Box](https://docs.scs.community/docs/iaas/guides/deploy-guide/examples/cloud-in-a-box) möglich ist (jede Komponente existiert genau einmal), ist es daher auch sehr sinnvoll, die verschiedenen
Komponenten in einem Szenario zu testen, das einem produktiven Setup ähnlicher ist, indem die verschiedenen Komponenten
in einem Cluster-Modus betrieben werden. Auf diese Weise können auch einige [nicht-funktionale](https://en.wikipedia.org/wiki/Non-functional_requirement) Konfigurations- und
Implementierungsfragen im Testbed simuliert, entwickelt und verifiziert werden.

Als Basis bzw. zur Bereitstellung des Testbeds werden virtuelle Maschinen, Netzwerk und Storage auf Basis von OpenStack verwendet.
Das Testbed kann damit grundsätzlich in einer Openstack Cloud Umgebung ein SCS System System zu Test- und Entwickungszwecken betreiben.
(Da SCS prinzipbedingt auch selbst Systeme virtualisiert, muss die OpenStack Umgebung die Fähigkeiten zur Nested Virtualization bereitstellen.)

Das SCS Testbed nutzte bisher Terraform, um die Basis für die benötigten Infrastrukturkomponenten automatisiert aufzubauen bzw. zu verwalten.
Terraform wurde bisher unter der Mozilla Public License v2.0 veröffentlicht und passte daher von den Nutzungsbedingungen bzw.
hinsichtlich seiner Offenheit gut zum OSISM bzw. SCS Projekt.

Mit der [Ankündigung](https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license) vom 10. August 2023 hat Hashicorp bekannt gegeben, dass sich dies in Zukunft ändern wird - zukünftige
Versionen werden zumindest in relevanten Teilen unter der Business Source License v1.1 zur Verfügung gestellt.
Da wir ein sehr großes Interesse daran haben, dass unser Projekt auf ernsthaften Open Source Komponenten aufbaut,
war absehbar, dass wir hier eine sinnvolle Alternative finden müssen die unseren Anforderungen entspricht.

Glücklicherweise hat sich schon am 2. September 2023 die Gründung eines Terraform Forks ergeben, der unter dem Dach
der Linux Foundation unter den Lizenzbedingungen der Mozilla Public License 2 weiterentwickelt wird.
Mit dem ersten offiziellen und stabilen Release von [OpenTofu](https://opentofu.org/] stellt OSISM und SCS nun seine Infrastructure-as-Code
Realisierung im Testbed auf OpenTofu in der Version 1.6.0 um.

Die Migration gestaltete sich sehr einfach: OpenTofu kann aus unserer Sicht guten Gewissens als DropIn Replacement für Terraform bezeichnet werden.

Mit dem heute integrierten Code-Stand haben wir noch einige Detailverbesserungen bei der Installation der
Abhängigkeiten bzw. der [Dokumentation](https://docs.osism.tech/testbed/) des Testbeds vorgenommen.
So ist es jetzt nur noch notwendig `make`, `wireguard` und `python-virtualenv` auf dem Rechner des Testbed-Benutzers zu installieren.
Alle anderen Abhängigkeiten wie OpenTofu aber auch Ansible werden nun passend zum Stand des Git-BRanch installiert bzw. verwaltet.
Auf diese Weise erreichen wir, dass die Testbed-Nutzer in Zukunft weniger Aufwand bei der Verwaltung der Tools haben und
dass für das Testbed sichergestellt ist, dass es mit den richtigen Tools in den richtigen Versionen genutzt wird.

Abschließend möchte ich noch einmal meine Begeisterung für OpenSource im Zusammenhang mit Terraform zum Ausdruck bringen.
Die bisherige Offenheit von Terraform und das Engagement der Community haben hier dafür gesorgt, dass wir mit geringem
Aufwand auf ein alternatives und zukunftssicheres Produkt migrieren können.
