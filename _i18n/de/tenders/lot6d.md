## Vergabepaket 6d

### Werkzeuge rund um Kubernetes

Um Containeranwendungen in Kubernetes (k8s) Clustern entwickeln und
bereitstellen zu können, benötigt man einige Hilfsmittel. Für die automatische
Installation der Containeranwendungen sollen Standardmechanismen bereitgestellt
werden. Werkzeuge und Abläufe zur Automatisierung der Validierung der
Containeranwendungen werden gebraucht. Anwendungsentwickler:innen benötigen
auch die Möglichkeit, Metriken aus der Anwendung zu sammeln und somit Analysen
zur Leistung der Anwendung zu erfassen. Im Fehlerfall sollen Fehler auch über
die verschiedenen Schichten der Plattform nachverfolgt werden können.

### IaC Werkzeuge

Anwendungsentwickler wollen gemeinsam (DevOps) mit den Kollegen zum
Anwendungsbetrieb für die Anwendungen automatisiert (virtuelle) Infrastruktur
bereitstellen. Dies findet täglich im Rahmen von Testintegrationsläufen statt
und weniger häufig aber regelmäßig und mit Hilfe derselben Automatisierung für
die produktive Bereitstellung von neueren Versionen der Anwendung. Die
automatische Kontrolle der (agilen) Infrastruktur mittels Software wird
Infrastructure-as-Code genannt und erfolgt in aller Regel mit Hilfe von
Werkzeugen wie terraform, ansible oder dergleichen. Aufgabe des SCS Projekts
ist es, dafür zu sorgen, dass diese Werkzeuge SCS Umgebungen hervorragend
unterstützen und diese Unterstützung auch wieder durch automatische
Testprozeduren abgesichert wird.

