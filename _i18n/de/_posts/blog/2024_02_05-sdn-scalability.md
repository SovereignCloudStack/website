---
layout: post
title: "Verbesserungen der SDN-Skalierbarkeit"
author:
  - "Angel Kafazov"
avatar:
  - "akafazov.jpg"
about:
  - "akafazov"
---

# Das Data-Center-Netzwerk

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/dc-network-architectures.png" @path %}">
    {% asset 'blog/dc-network-architectures.png' class="figure-img w-100" %}
  </a>
</figure>

Ein modernes Rechenzentrumsnetzwerk verwendet typischerweise eine zweistufige Spine-Leaf-Netzwerkarchitektur. Traditionellere 3-Tier-Architekturen sind weniger beliebt.

In einem Spine-Leaf-Netzwerk sind alle Server in einem Rack mit einem einzelnen TOR (Top of Rack) oder Leaf-Switch verbunden. Jeder der Leaf-Switches ist mit allen Spine-Switches im Layer darüber verbunden, die die verschiedenen Racks verbinden. Es gibt keine Verbindungen zwischen den Leaf-Switches oder zwischen den Spine-Switches auf derselben Ebene. Diese Art von Netzwerk erleichtert die Skalierbarkeit, da es einfacher zu unterstützen ist.

Auf diesem physischen Netzwerk, auch Underaly genannt, basieren alle Funktionen des Software Defined Networking (SDN). Das SDN ist das von Endbenutzern verwaltete virtuelle Netzwerk und verbindet VMs, Container und manchmal physische Server. Das SDN ist vollständig virtualisiert und muss unter Berücksichtigung der physischen Topologie entworfen und implementiert werden, um die gewünschten Anforderungen an Leistung, Funktionalität und Skalierbarkeit zu erfüllen.

# Überblick über SDN in Openstack

Software Defined Networking (SDN) bezieht sich auf ein Netzwerkkonzept, bei dem softwarebasierte Controller und APIs zur Steuerung des Netzwerkverkehrs anstelle der Netzwerkhardware verwendet werden. In Openstack werden SDN-Netzwerke verwendet, um Benutzernetzwerke für virtuelle Maschinen und Container auf der physischen Netzwerkinfrastruktur zu erstellen und zu verwalten. Beide Arten von Netzwerken werden auch als Underlay (physikalisch) und Overlay (SDN) bezeichnet. Größere Anwendungsfälle (Hyperscaler) und eine erhöhte Anzahl von Container-Workloads belasten den SDN-Stack.

Openstack Neutron ist die Hauptkomponente, die für die Vernetzung verantwortlich ist. Es nutzt stark Open-Source-Technologien wie OVN/OVS und kommuniziert auch mit dem zugrunde liegenden Netzwerk, um Benutzern Netzwerkdienste auf höherer Ebene bereitzustellen. ML2 ist das Neutron-Plugin, das für die Kommunikation mit dem physischen Netzwerk verantwortlich ist und über mehrere Treiber verfügen kann, die jeweils bestimmte Hardware-/Anbietergeräte unterstützen. Der SDN-Stack ist verteilt, wobei einige Komponenten auf dedizierten Netzwerkknoten, Netzwerkgeräten und auch auf den Servern ausgeführt werden.

Wenn Openstack wächst, muss sein Netzwerk mitwachsen. Wenn wir über die SDN-Skalierbarkeit sprechen, gibt es mehrere Aspekte, die von der tatsächlichen Netzwerkarchitektur abhängen. Im Folgenden gehen wir näher darauf ein, aber einige wichtige Punkte, die es zu berücksichtigen gilt, sind SDN-Engpässe (OVN-Control-plane, Netzwerkknotenressourcen), Unterstützung für die Anzahl von Mandanten und Netzwerken sowie die tatsächliche Leistung der Datenebene. In diesem Beitrag werden wir diese Herausforderungen und Strategien zur Verbesserung der SDN-Skalierbarkeit in Openstack/SCS untersuchen.

## SDN Stack

In diesem Abschnitt werfen wir einen Blick auf die weiteren Softwarekomponenten, die zur Implementierung von SDN in Openstack erforderlich sind.

### Neutron

Neutron ist ein OpenStack-Projekt zur Bereitstellung von „Netzwerkkonnektivität als Dienst“ zwischen Schnittstellengeräten (z. B. vNICs), die von anderen OpenStack-Diensten (z. B. Nova) verwaltet werden. Es implementiert die OpenStack Networking API. Neutron ist für die zentrale Verwaltung von Mieternetzwerken, Geräten und Adressvergabe verantwortlich. Es orchestriert das Netzwerk und die Geräte, indem es Plugins und Treiber für jede einzelne im Stapel unten ausgewählte Technologie verwendet.

### OVN/OVS

Open Virtual Network (OVN) und Open vSwitch (OVS) sind integrale Bestandteile der Netzwerkarchitektur von Neutron. OVN bietet Netzwerkvirtualisierung und bietet logische Netzwerkabstraktionen wie logische Switches und Router. Es dient als Steuerungsebene für OVS, einen leistungsstarken, mehrschichtigen virtuellen Switch. Zusammen ermöglichen OVN/OVS dynamische, programmierbare Netzwerk-Setups, die ein effizientes Routing, Switching und Bridging des Datenverkehrs in virtualisierten Umgebungen ermöglichen. Ihre Integration mit Neutron erleichtert komplexe Netzwerkszenarien und gewährleistet Skalierbarkeit und Flexibilität bei der Handhabung des Netzwerkverkehrs innerhalb von OpenStack-Bereitstellungen.

### BGP/EVPN

Border Gateway Protocol (BGP) und Ethernet Virtual Private Network (EVPN) sind Technologien, die in Verbindung mit Neutron für erweiterte Netzwerkfunktionen verwendet werden. BGP ist ein standardisiertes externes Gateway-Protokoll, das für den Austausch von Routing- und Erreichbarkeitsinformationen zwischen autonomen Systemen im Internet entwickelt wurde. EVPN erweitert BGP, um skalierbare, mandantenfähige Layer-2-VPN-Dienste zu unterstützen. In Neutron wird BGP/EVPN für effizientes Routing und Segmentierung in großen Cloud-Umgebungen verwendet. Es ermöglicht robustere und flexiblere Netzwerklösungen, indem es dynamische Routenanzeige, verbesserte Verkehrstechnik und nahtlose Integration in bestehende Netzwerkinfrastrukturen ermöglicht.

### Tunnelprotokolle – VXLAN/Geneve

Virtual Extensible LAN (VXLAN) und Generic Network Virtualization Encapsulation (Geneve) sind Netzwerk-Overlay-Protokolle, die in Openstack und OVN/OVS zum Tunneln des Netzwerkverkehrs über bestehende Netzwerkinfrastrukturen verwendet werden. VXLAN wird häufig zum Kapseln von Ethernet-Frames über einen UDP-Tunnel verwendet, wodurch Layer-2-Netzwerke über Layer-3-Netzwerke erweitert werden können. Geneve, ein neueres Protokoll, bietet ähnliche Funktionen, jedoch mit zusätzlicher Flexibilität und Erweiterbarkeit. In Openstack ist VXLAN/Geneve von entscheidender Bedeutung für die Erstellung isolierter, mandantenfähiger Netzwerke über eine gemeinsam genutzte physische Netzwerkinfrastruktur. Diese Kapselung ermöglicht eine skalierbare Netzwerksegmentierung und bietet sichere und effiziente Kommunikationskanäle innerhalb von Cloud-Umgebungen.

## Physisches Netzwerk

Die physische Netzwerkschicht ist von entscheidender Bedeutung, da sie die grundlegende Infrastruktur bereitstellt, über die alle virtualisierten Netzwerkfunktionen ausgeführt werden. Auf dieser Ebene sind in der Regel verschiedene Hardwareanbieter beteiligt, die die physische Netzwerkausrüstung wie Switches, Router und andere Netzwerkhardware bereitstellen. Diese Geräte sind für die eigentliche Datenübertragung und Weiterleitung in einer physischen Einrichtung unerlässlich. Netzwerkbetriebssysteme (NOS) sind ebenfalls eine Schlüsselkomponente der physischen Netzwerkschicht. NOS ist die Software, die auf den Netzwerkgeräten läuft und es ihnen ermöglicht, Netzwerkfunktionen auszuführen und mit übergeordneten SDN-Controllern und -Anwendungen zu interagieren. In OpenStack spielt das ML2-Plugin (Modular Layer 2) in Neutron eine wichtige Rolle in der physischen Netzwerkschicht. ML2 bietet eine Abstraktionsschicht, die mehrere Netzwerkmechanismen auf steckbare Weise unterstützt und es Neutron ermöglicht, mit verschiedenen Arten von Netzwerkhardware und -technologien zu kommunizieren. Diese Plugin-Architektur stellt sicher, dass Neutron mit einer Vielzahl physischer Netzwerkgeräte und -konfigurationen arbeiten kann und ermöglicht so Flexibilität und Skalierbarkeit in der physischen Netzwerkinfrastruktur einer OpenStack-basierten SDN-Bereitstellung.

## Bare-Metal-Hosts

Bare-Metal-Hosts spielen im Kontext von OpenStack und SDN eine wichtige Rolle bei der Bereitstellung leistungsstarker, nicht virtualisierter Rechenressourcen. Diese Hosts sind in der Regel mit fortschrittlichen Netzwerkschnittstellenkarten (NICs) wie SmartNICs und Datenverarbeitungseinheiten (DPUs) ausgestattet. SmartNICs sind intelligente Netzwerkkarten, die Verarbeitungsaufgaben entlasten, die normalerweise von der Server-CPU erledigt werden. Dazu gehören Aufgaben wie Traffic Shaping, Ver-/Entschlüsselung und Netzwerkpaketverarbeitung. Der Einsatz von SmartNICs kann zu einer verbesserten Leistung und einer geringeren CPU-Last auf den Bare-Metal-Hosts führen.

DPUs sind eine weitere Schlüsselkomponente in Bare-Metal-Hosts und bieten ähnliche Funktionalitäten wie SmartNICs, können aber mit zusätzlichem Betriebssystem unabhängig vom Host-Betriebssystem vom Dienstanbieter verwaltet werden. Dies macht sie ideal für Openstack-Bereitstellungen für physische Server, da die vom Rechenzentrum bereitgestellten SDN- und Kernnetzwerkfunktionen zentral verwaltet werden können, ohne den Benutzer zu beeinträchtigen.

Die Integration von SmartNICs und DPUs in Bare-Metal-Hosts innerhalb einer OpenStack-Umgebung erhöht die Flexibilität, Effizienz und Leistung des Netzwerks. Dieses Setup ist besonders vorteilhaft für Workloads, die einen hohen Durchsatz, geringe Latenz und sichere Netzwerkkommunikation erfordern. Daher sind Bare-Metal-Hosts, die mit diesen fortschrittlichen NICs ausgestattet sind, ein wesentlicher Bestandteil moderner SDN-Architekturen, insbesondere in Umgebungen, in denen Leistung und Sicherheit von entscheidender Bedeutung sind.

# Gängige Netzwerkdesigns

Im Folgenden werfen wir einen genaueren Blick auf gängige Netzwerkdesigns, die für Openstack-Bereitstellungen verwendet werden.

## VLANs

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/VLANs_network_design.png" @path %}">
    {% asset 'blog/VLANs_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

VLANs sind das einfachste und gebräuchlichste Design für sehr kleine Benutzer, die mit der Nutzung von OpenStack beginnen.

Diese Art von Netzwerk nutzt VLANs zwischen Netzwerk-Switches und Server für den SDN-Verkehr. Benutzerarbeitslasten wie VMs und Container auf dem Server sind normalerweise mit OVS an ein VLAN gebunden. Neutron orchestriert den Prozess der Erstellung und Verwaltung von Benutzernetzwerken sowohl auf der Netzwerkebene (Underlay-Netzwerk) als auch auf den Servern. Das ML2-Plugin und die Treiber werden verwendet, um mit den Netzwerkgeräten und der OVN/OVS-Steuerungsebene auf dem Server zu kommunizieren.

Benutzer haben die Möglichkeit, entweder alle VLANs im Voraus bereitzustellen, sodass bei Erscheinen eines neuen Tenantnetzwerks dieses an ein vorhandenes VLAN angeschlossen werden kann, ohne erneut mit den Netzwerkgeräten kommunizieren zu müssen. Die Alternative besteht darin, ML2 zu verwenden, um neues VLAN dynamisch zu konfigurieren, bevor jedes Mandantennetzwerk erstellt wird.

### Vorteile

- Ein solches Netzwerk ist einfach und unkompliziert zu implementieren. Dies kann weiter vereinfacht werden, indem alle VLANs im physischen Netzwerk vorab bereitgestellt werden und ML2 möglicherweise eliminiert wird. Dies ist ein guter Ansatz für Testumgebungen und kleine Bereitstellungen.

### Nachteile

– Vor allem lassen sich VLANs für SDN nicht gut skalieren. Erstens haben wir eine theoretische Grenze von 4096 VLANs auf jedem Netzwerk-Switch. Eine realistischere Grenze wären etwa 100 Openstack-Tenants.
- Der Ansatz ist auch sehr fragil. Eine einzelne VM kann das gesamte Netzwerk lahmlegen und so einen riesigen Explosionsradius freilegen. Außerdem sind Netzwerk-Switches dafür bekannt, dass sie die VLAN-Konfiguration beibehalten können. Wenn ein Switch ausfällt, muss seine Konfiguration nach dem Hochfahren erneut durchgeführt werden, was zu erheblichen Ausfallzeiten führt.
– Ein weiterer Nachteil, den wir hier sehen, ist die Einbeziehung des physischen Netzwerks, das zur Unterstützung des SDN erforderlich ist. Für jedes neue Benutzernetzwerk in Openstack müssen neue VLANs erstellt und angehängt werden. Selbst im vorab bereitgestellten Szenario müssen die VLANs noch im Underlay vorhanden sein, was schließlich zu einem Engpass führt.

## Netzwerkzentriertes SDN

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/Network_centric_network_design.png" @path %}">
    {% asset 'blog/Network_centric_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

Dieses Netzwerkdesign verwendet einen stärker netzwerkzentrierten Ansatz, indem die meisten SDN-Funktionalitäten in den physischen Netzwerkgeräten implementiert werden. Der entscheidende Punkt ist, dass eine Art Tunnelprotokoll wie VXLAN oder Geneve verwendet wird, um Benutzernetzwerkpakete zu kapseln und über das Netzwerk zu transportieren. In einer Spine-Leaf-Topologie beendet das Leaf oder ToR VXLAN-Endpunkte. Auf der Steuerebene wird BGP (EVPN) zur Übertragung von Adressierungsinformationen zwischen Switches verwendet.

Auf der Serverseite wird dem ToR-Switch für jedes Mandantennetzwerk ein reguläres VLAN bereitgestellt. Da nicht alle Mandantennetzwerke auf jedem ToR-Switch benötigt werden, lässt sich dieses Design besser skalieren als reine VLANs. Außerdem sind zwischen den Switches keine VLANs erforderlich, da es sich bei der Underaly um Layer 3 handelt.

### Vorteile

- Diese Art von Netzwerk ist skalierbarer und kann problemlos bis zu 1000 Openstack-Mandanten verwalten. Aufgrund des kleineren Explosionsradius ist es außerdem stabiler und widerstandsfähiger gegenüber Veränderungen.
- Da das gesamte SDN auf die physischen Geräte verlagert wird, führen Server-CPUs keine VXLAN-Encaps/Decaps durch und können die Benutzer frei bedienen. Die Verarbeitung umfangreicher Datenebenen erfolgt auf dedizierter Netzwerkhardware, die speziell für diese Aufgabe entwickelt wurde. Daher sind auf den Servern keine SmartNICs oder DPUs erforderlich, was kosteneffizienter ist.

### Nachteile

- Da ein netzwerkzentrierter Ansatz verwendet wird, ist das Netzwerk immer noch stark in das SDN eingebunden. Die zuvor aufgezeigten Nachteile physischer Geräte wie das Beibehalten der Switch-Konfiguration gelten weiterhin.
- Dieser Ansatz ist auch komplexer als reine VLANs, da er erfordert, dass das Netzwerk Routing-Protokolle wie BGP und BFD ausführt. Neutron muss noch über ML2 mit den Switches kommunizieren.
- Wichtig ist, dass der Verkehr zwischen Mieternetzwerken (Ost/West und Nord/Süd) über die Netzwerkknoten geleitet wird, was zu einem Engpass werden kann. Obwohl dieses Design hinsichtlich der Skalierbarkeit besser ist, weist es bei sehr großen Bereitstellungen dennoch Einschränkungen auf.

## Serverzentriertes SDN

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/Server_centric_network_design.png" @path %}">
    {% asset 'blog/Server_centric_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

Beim serverzentrierten Netzwerkdesign werden SDN-Softwarefunktionen auf den Servern und nicht auf den Netzwerkgeräten implementiert. Tunnelprotokolle wie VXLAN haben abschließende Endpunkte auf den Servern und die Adressen für diese Endpunkte werden über Protokolle der Steuerebene wie BGP/EVPN ermittelt. Auch Encap/Decap und Kryptoverarbeitung werden auf dem Server durchgeführt.

Diese Art von Design reduziert die Abhängigkeit vom Netzwerk zur Ausführung von SDN-bezogenen Aufgaben erheblich. Das Underlay muss Layer 3 sein und BGP ausführen, um serverzentriertes SDN zu ermöglichen. An die Underlay werden keine weiteren Anforderungen gestellt.

Aufgrund der begrenzten Einbindung des Underlay-Netzwerks lässt sich dieses Design sehr gut skalieren. Der Nachteil ist jedoch, dass die Datenpfadverarbeitung auf dem Server erfolgt. Ein Beispiel für eine solche Verarbeitung ist die VXLAN-Kapselung/Entkapselung. Wenn auf dem Server keine DPU oder SmartNIC vorhanden ist, läuft diese Logik auf der CPU, was sich negativ auf deren Leistung auswirken kann. Daher ist der Einsatz von DPU/SmartNICs dringend erforderlich.

### Vorteile

- sehr skalierbar
- sehr effizientes Datenpfad-Routing (Ingress/Egress)
- einfache Underlay
- Keine Netzwerkorchestrierung in Openstack

### Nachteile

- komplexer Server
- Möglicherweise sind SmartNICs und DPUs erforderlich, um die Server-CPU zu entlasten
- Routing-Protokolle müssen auf dem Server ausgeführt werden

## Hybrid – SDN sowohl auf Servern als auch auf Switches

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/Hybrid_network_design.png" @path %}">
    {% asset 'blog/Hybrid_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

Als Erweiterung des serverzentrierten Designs unterstützt das Hybridnetzwerk Bare-Metal-Knoten, die einzelnen Benutzern zugewiesen sind. Da der Benutzer vollen Zugriff auf das Betriebssystem des Servers hat, kann die SDN-Funktionalität nicht zusammen mit Anwendungen bereitgestellt werden, da sie vom Dienstanbieter verwaltet wird. Daher müssen wir SDN auf einigen Netzwerk-Switches ausführen, die mit Bare-Metal-Servern verbunden sind, und an anderen Orten SDN direkt auf dem Server ausführen, wenn diese nur VMs hosten. Für SDN haben wir zwei Möglichkeiten:

- Dedizierter Kunden-Switch, angeschlossen an einen einzelnen Bare-Metal-Knoten
- eine DPU-Karte, die am Bare-Metal-Knoten angeschlossen ist

SmartNIC ist hier keine gute Lösung, da es enger an den Hostknoten gekoppelt und dem Endbenutzer zugänglich ist. DPUs und Switches können vom Anbieter unabhängig verwaltet werden, sodass der Benutzer keinen Zugriff darauf benötigt.

# Unsere Lösung

In unserem Bestreben, die Skalierbarkeit und Leistung von SDN-Netzwerken innerhalb des Sovereign Cloud Stack (SCS) zu verbessern, haben wir verschiedene Ansätze untersucht. Unser Fokus liegt auf der Nutzung modernster Netzwerkdesigns und -technologien wie SONiC, um den wachsenden Anforderungen moderner Netzwerkinfrastrukturen gerecht zu werden.

## Netzwerkdesign – VXLAN auf Servern

Für Szenarien, die ein „VXLAN auf Servern“-Netzwerkdesign verwenden, legen wir Wert auf die Verwendung von SmartNICs und Data-Processing-Units (DPUs), um die Leistungsmerkmale der Datenebene des Netzwerks erheblich zu verbessern.

### SmartNICs and DPUs

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/nvidia-bluefield-3-dpu-3c33-d.jpg" @path %}">
    {% asset 'blog/nvidia-bluefield-3-dpu-3c33-d.jpg' class="figure-img w-100" %}
  </a>
</figure>

SmartNICs und DPUs spielen eine entscheidende Rolle bei der Steigerung der Paketverarbeitungsgeschwindigkeit im Netzwerk. SmartNICs sind besonders vorteilhaft für virtuelle Maschinen (VMs), da sie Tunnel-, Kapselungs-/Entkapselungs- und Verschlüsselungsfunktionen bieten, die für SDN-Protokolle unerlässlich sind. Durch die Auslagerung von Routing- und SDN-Protokollaufgaben auf den Server steigern SmartNICs die CPU-Leistung und bieten Kosteneinsparungsvorteile.

Andererseits eignen sich DPUs ideal für Umgebungen, in denen Endbenutzer direkt auf Bare-Metal-Server zugreifen. DPUs stellen den nächsten Evolutionsschritt über SmartNICs hinaus dar und bieten den entscheidenden Vorteil, dass sie vom Netzwerkbetreiber unabhängig und unabhängig von der Benutzerkontrolle verwaltet werden. Innerhalb von SCS stellen wir die wesentlichen Infrastruktur- und Konfigurationsfunktionen bereit, sodass Benutzer mühelos SmartNIC- und DPU-Funktionen in ihren Netzwerken einrichten und verwalten können.

## Netzwerkdesign – VXLAN auf Switches

Wenn SDN-Protokolle direkt auf Netzwerk-Switches implementiert werden, besteht unser Ansatz darin, den Einsatz von SONiC zusammen mit Verbesserungen bei Tools und Automatisierung zu untersuchen, um eine effektive Skalierung zu ermöglichen.

### SONiC

Zu unserer Strategie gehört die Stärkung der Unterstützung für SONiC, ein leistungsstarkes Open-Source-Netzwerkbetriebssystem, das Netzwerkskalierbarkeit und -flexibilität ermöglicht.

### Tooling – Automatisieren von SONIC-Rollout und -Konfiguration

Wir sind bestrebt, die Tools, Konfiguration und Dokumentation zu verbessern, um die Einführung dieser Netzwerkarchitektur in SCS zu erleichtern. Dazu gehören Verbesserungen in OSISM und Kolla Ansible sowie die Integration von Netbox. Netbox dient als Quelle der Wahrheit und ermöglicht die Generierung erster Rollout-Konfigurationen für OSISM und Kolla Ansible. Darüber hinaus wollen wir Observability und Monitoring für SONiC-basierte Netzwerkgeräte in SCS integrieren und dabei die vorhandenen Monitoring von SONiC nutzen.

## Physisches Netzwerk

Unsere Bemühungen erstrecken sich auf die Verbesserung der dynamischen Konfiguration des physischen Netzwerks von OpenStack. Dazu gehört die Erkundung des vorhandenen ML2/Network-Generic-Switch-Treibers und die Erweiterung seiner Funktionen zur Unterstützung von VXLAN und Geneve. Wir prüfen auch andere Treiber/Plugins und das Potenzial für die Entwicklung eines neuen SCS-Plugins für Neutron. Erweiterungen im Zusammenhang mit SCS in SONiC können unabhängig paketiert und auf jeder kommerziellen oder Community-Version von SONiC installiert werden.

## SDN-Stack

Eine besondere Herausforderung innerhalb der OpenStack-Netzwerkknoten ist der Engpass, der durch die OVN-Steuerungsebenensoftware (Open Virtual Network) verursacht wird. Eine vielversprechende Lösung ist die Migration der OVN-Steuerungsebene auf SONiC. Dieser Schritt würde es der OVN-Steuerungsebene ermöglichen, verteilt zu arbeiten und mehrere vorhandene SONiC-Geräte im Netzwerk für eine verbesserte Leistung zu nutzen. Ein potenzieller Nachteil ist jedoch die Ressourcenintensität von OVN, die die begrenzten Ressourcen auf SONiC-Geräten belasten könnte. Unser Ansatz umfasst die sorgfältige Bewertung dieser Überlegungen, um eine ausgewogene und effiziente SDN-Stack-Implementierung sicherzustellen.

