---
layout: post
title:  "Cluster Stacks"
authors: 
- "Janis Kemper"
- "Sven Batista Steinbach"
- "Jan Schoone"
- "Alexander Diab"
---
## Cluster Stacks

Der Sovereign Cloud Stack hat mit dem Release 5 eine Technical Preview der "Cluster Stacks" veröffentlicht - einem Framework, welches den Produktivbetrieb von Kubernetes-Clustern aus Nutzerperspektive vereinfacht sowie Transparenz bezüglich der Konfiguration und Zusammenstellung der Kernkomponenten der Cluster bietet.
Damit schafft SCS eine dezentrale und anwenderorientierte Alternative zu den häufig intransparenten und untereinander inkompatiblen kommerziellen "Managed Kubernetes"-Angeboten.

## Kubernetes - schwieriger als gedacht
Einen Kubernetes-Cluster zu betreiben ist grundsätzlich nicht schwierig. Einfache Kubernetes-Cluster erfüllen allerdings in der Regel nicht die Anforderungen für einen Produktivbetrieb in Bezug auf Stabilität, Sicherheit und Verlustfreiheit. Ein Kubernetes-Cluster in einer Produktionsumgebung muss aufwändig konfiguriert werden, etwa in Bezug auf wichtige Kern-Applikationen und Node-Images, um zum Beispiel gegen Cyber-Angriffe abgesichert zu sein. Fehlendes Wissen führt in der Praxis häufig dazu, dass Unternehmen nicht abgesicherte Cluster für echte Workloads verwenden, welche durch die stark steigende Anzahl von Cyber-Angriffe gefährdet sind.
Ein anderes Problem ist die häufig fehlende Test-Infrastruktur, ohne die Updates von Produktions-Clustern fehleranfällig sind. In der Folge werden Cluster oft nur einmal im Jahr gezwungenermaßen geupdatet, da die genutzte Kubernetes-Version nicht mehr unterstützt wird.

## Proprietäre und intransparente Lösungen
Viele Anwender greifen daher entweder auf einen "Managed Kubernetes"-Service eines Infrastruktur-Anbieters, oder, wenn sie die Kubernetes-Umgebung selbst betreiben, auf ein kommerzielles und damit meistens einhergehend proprietäres Produkt (z.B. OpenShift) zurück.
Diese Lösungen sind in der Regel so spezifisch in Konfiguration und der Auswahl der Komponenten, dass ein Wechsel extrem aufwändig und ressourcenintensiv ist. Dazu ist eine gehostete "Managed"-Lösung häufig intransparent in Bezug auf Aufbau und Funktion - was eine zusätzliche Abhängigkeit erzeugt. Es ist selten verständlich, wie Cluster aufgebaut sind und welche Schritte ein Kunde noch selbstständig durchführen muss, um ein Cluster sicher und produktionsreif zu betreiben. Da diese Schritte bei jedem Anbieter anders aussehen, sind Migrationen oder das Nutzen mehrerer Anbieter entsprechend schwierig.
Je nach Angebot können mehr oder weniger Zuständigkeiten beim Nutzer liegen. Dies kann dazu führen, dass bei dem einen Angebot bestimmte Sicherheitseinstellungen oder wichtige Komponenten schon eingebaut sind, beim anderen aber nicht. Ein Nutzer muss sich daher bei jedem Wechsel eines Anbieters intensiv mit den Details des Produkts auseinandersetzen, um dann die richtigen Konsequenzen ziehen zu können und die noch fehlenden Einstellungen selbst umzusetzen und fehlende Komponenten zu installieren.

## Cluster Stacks - die Lösung für produktionsreifes und einfaches Kubernetes
Hier setzen die Cluster Stacks von SCS an und schaffen eine Lösung, in der Aufbau eines Clusters auch bei einer "Managed"-Lösung transparent bzw. vollständig open-source ist und sich Nutzer in einer Community zusammenschließen können, um die gemanagte Lösung gemeinsam mit den Anbietern zu verbessern. Sie basiert auf dem open-source Kubernetes-Projekt "Cluster-API", welches es ermöglicht, schnell und einfach sichere Cluster zu erstellen und zu betreiben - auch auf verschiedenen Providern.
Die Cluster Stacks sind ein Konzept, welches alle wichtigen Komponenten eines Kubernetes-Clusters zusammen denkt. Die drei Hauptkomponenten sind dabei
1. Konfiguration von Kubernetes (z.B. Kubeadm),
2. grundlegende Applikationen,
3. Node Images.
Diese drei Elemente werden in Cluster Stacks zusammengefasst und als Ganzes getestet. Nur wenn alles zusammen funktioniert und ein Upgrade von der vorherigen Version möglich ist, wird ein Cluster Stack released und seine Funktion somit gesichert. Die häufigen Probleme bei Updates von Kubernetes-Clustern gibt, werden so vermieden.
Außerdem vereinfacht der [SCS Cluster Stack Operator](https://github.com/SovereignCloudStack//cluster-stack-operator) das Benutzen der [Cluster Stacks](https://github.com/SovereignCloudStack//cluster-stacks). Zusammen mit der Cluster-API können so über simple API-Aufrufe neue, produktionsreife Cluster erstellt oder bestehende upgedatet werden.

## Cluster Stacks als Framework
Die Cluster Stacks sind ein Konzept, welches für alle Provider offen steht und auf Basis der Cluster-API die Möglichkeit schafft, Cluster zu erstellen und zu verwalten. Dabei kann auf bestehende Cluster Stacks zurückgegriffen werden oder es können eigene erstellt werden, um z.B. weitere Provider zu unterstützen oder bestimmte Anforderungen hinzuzufügen.
Im Rahmen des SCS-Projekts werden Cluster Stacks für ausgewählte Provider bereitgestellt und garantieren so einen SCS-standardisierten Einsatz von Kubernetes. Abgesehen davon, dass Cluster-API als Technologie vorausgesetzt wird, haben die Cluster Stacks keine Abhängigkeiten.

## Ausblick
Der Release R5 enthält einen Technical Preview der Cluster Stacks, des dazugehörigen Operators, sowie eine [Demo](https://github.com/SovereignCloudStack/cluster-stacks-demo), mithilfe derer Nutzer schon jetzt Cluster lokal mithilfe von Docker starten können.
In den kommenden Wochen wird eine OpenStack-Schnittstelle für OpenStack veröffentlicht, sodass die Cluster Stacks auf "echter" Cloud-Infrastruktur genutzt werden können.
