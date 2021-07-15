# 2021-07-15: SCS Release 0 freigegeben

Wir freuen uns, die Release 0 von Sovereign Cloud Stack freizugeben.

Während wir erst vor wenigen Tagen die offizielle Projektfinanzierung erhalten
haben, haben wir dennoch bereits eine Community aufgebaut, welche nützliche
Arbeit durch gemeinschaftliche Software Entwicklung leisten konnte.

R0 ist das Ergebnis von mehr als einem Jahr Arbeit, welche alle auf github
nachvollziehbar ist. 
[SCS](https://github.com/SovereignCloudStack/) verlässt sich stark auf
[OSISM](https://github.com/OSISM/), wir bauen also auf vielen Jahren Arbeit
dort auf. Eine Menge Arbeit aus SCS ist dorthin zurückgeflossen.
SCS und OSISM bauen beide natürlich tausenden Personenjahren Arbeit
der upstream Communities auf. Wir stehen auf den Schultern von Riesen.

Wir sind stolz darauf, was wir mit unseren Community aus Freiwilligen
erreichen konnten! Die Automatisierung fürs Lifecycle Management der
(containerisierten) Basisinfrastruktur, Betriebswerkzeuge, Nutzer- und
Zugriffsmanagement, und die IaaS Schicht sind grundsolide.
Die ersten zwei Partner, [betacloud](https://betacloud.de) und 
[PlusServer](https://www.plusserver.com/produkte/pluscloud) nutzen
SCS schon für ihre produktiven Clouds und weitere sind schon unterwegs.
Wir haben die Demonstrator (gx-scs) Umgebung von PlusCloudOpen
mit [openstack-health-monitor](https://github.com/SovereignCloudStack/openstack-health-monitor)
überwacht und haben nun über Wochen eine einzige Warnung wegen Langsamkeit
und keinen einzigen Alarm beobachtet. Das ist eine große Errungenschaft.

Wir möchten allen danken, die zu dieser Release beigetragen haben.

R0 ist auf die Installation des [testbed](https://docs.osism.tech/testbed/) fokussiert.
Wir wollen es zum jetzigen Zeitpunkt allen möglichst einfach machen, SCS zum
Zweck des Testens, der Inspektion, Mitarbeit, Vergleich, Inspiration ... 
zu installieren.
Das soll niemanden davon abhalten, eine produktive Installation auf
Blech durchzuführen. Wie erwähnt haben wir ja bereits zwei Cloudanbieter
mit SCS in Produktion. Das Testbed zu erkunden ist aber typischerweise der
erste Schritt. Nehmen Sie Kontakt mit uns auf, wenn Sie schon mit dem
Testbed vertraut sind und jetzt den nächsten Schritt gehen wollen.

Wir haben in den vergangenen Tage eine Menge Dokumentation auf den aktuellen
Stand gebracht. Nutzen Sie unser [github Docs](https://github.com/SovereignCloudStack/Docs/)
repository als Einstiegspunkt. Für R0 gibt es
[spezifische Release Notes](https://github.com/SovereignCloudStack/Docs/blob/main/Release-Notes/Release0.md).
Die Dokumente sind natürlich auch von unserer ["SCS nutzen"](/GetIt/) Seite
in unserer [Webpräsenz](/index.html.de) verlinkt.

The Dokumentation erklärt, wie man eine Testbed Installation durchführen kann,
dokumentiert aber auch die Komponenten im Technical Preview Status
wie z.B. die Kubernetes aaS Bausteine, welche die
[k8s-cluster-api](https://github.com/SovereignCloudStack/k8s-cluster-api-provider)
nutzen. Dies wird eines der wichtigen zentralen Themen für R1 sein, welches wir bereits
im September herausgeben wollen. (Hinweis: Wir werden danach mit einem
6-monatigen Releasezyklus arbeiten, wobei die Wirklichkeit etwas kontinuierlicher
sein wird, als das jetzt klingt.)

Kontaktieren Sie uns mit Fragen oder Feedback. Wir freuen uns über github
issues und PullRequests, werden aber auch versuchen, alle 
[emails](mailto:project@scs.sovereignit.de) zu berücksichtigen.
