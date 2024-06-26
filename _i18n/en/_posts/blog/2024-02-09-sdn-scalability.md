---
layout: post
title: "SDN scalability improvements"
author:
  - "Angel Kafazov"
avatar:
  - "akafazov.jpg"
about:
  - "akafazov"
---

# Overview of SDN network scalability

Software-defined Networking (SDN) is a critical component of modern cloud environments, providing the necessary flexibility and scalability to meet the demands of large-scale network infrastructures. As the size and complexity of cloud deployments continue to grow, the need for scalable and efficient SDN solutions becomes increasingly important. In this post, we explore the challenges and strategies for improving SDN scalability within Sovereign Cloud Stack (SCS) and OpenStack environments.

# The data center network

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/dc-network-architectures.png" @path %}">
    {% asset 'blog/dc-network-architectures.png' class="figure-img w-100" %}
  </a>
</figure>

A modern data center network typically uses a 2-tier spine-leaf network architecture. More traditional 3-tier architectures are becoming less popular.

In a spine-leaf network, all servers are connected to one or two TOR (top of rack) or Leaf switches within a rack. All leaf switches are connected to all spine switches in the layer above. There are no direct connections between leaf or spine switches on the same tier. This kind of network facilitates scalability by being simple and easy to support.

On top of this physical network, also called underlay, all Software Defined Networking (SDN) features are built on top of. The SDN is the virtual network managed by end users and connects VMs, containers, and sometimes physical servers. The SDN is entirely virtualized and must be designed and implemented with the physical topology in mind to achieve the desired performance, functionality, and scalability requirements.

# Overview of SDN in OpenStack

Software-defined Networking (SDN) is a networking concept where software-based controllers and APIs direct network traffic rather than the networking hardware. In OpenStack, SDN networks are used to connect virtual machines and containers. The physical network is also referred to as the underlay, while SDN is called overlay. Larger operators and an increased number of containerized workloads put stress on the SDN stack.

OpenStack Neutron is the main component responsible for networking. It heavily leverages open-source technologies like OVN/OVS and communicates with the underlay network to provide higher-level network services to users. ML2 is the Neutron plugin responsible for communication with the physical network and can have multiple drivers each driver supporting particular hardware/vendor devices. The SDN stack is distributed where some components run on dedicated network nodes, network devices, and even servers.

When OpenStack traffic increases the network must scale accordingly. There are several aspects of SDN scalability and they depend on the actual network architecture. We dive deeper below, but some important points to consider are SDN bottlenecks (OVN control plane, network node resources), support for several tenants and networks, and actual data-plane performance. In this post, we will explore those challenges and strategies to improve SDN scalability in OpenStack and SCS.

## SDN stack

In this section, we will take a look at more software components needed to implement SDN in OpenStack.

### Neutron

Neutron is an OpenStack project to provide “network connectivity as a service” between interface devices (e.g., vNICs) managed by other OpenStack services (e.g., nova). It implements the OpenStack Networking API. Neutron is responsible for the centralized management of tenant networks, devices, and address allocation. It orchestrates the physical network, and the devices by using plugins and drivers for each particular technology chosen in the stack.

### OVN/OVS

Open Virtual Network (OVN) and Open vSwitch (OVS) are integral components of Neutron's network architecture. OVN provides network virtualization, offering logical network abstractions such as logical switches and routers. It is tightly coupled with OVS, which is a high-performance, multilayer virtual switch. Together, OVN/OVS enable dynamic, programmable network setups, allowing for efficient routing, switching, and bridging of traffic in virtualized environments. Their integration with Neutron facilitates complex networking scenarios, ensuring scalability and flexibility in handling network traffic within OpenStack deployments.

### BGP/EVPN

Border Gateway Protocol (BGP) and Ethernet Virtual Private Network (EVPN) are technologies used for advanced networking functionalities. BGP is a standardized exterior gateway protocol designed to exchange routing and reachability information among autonomous systems on the internet. EVPN extends BGP to support scalable, multi-tenant layer 2 VPN services. In SCS, BGP/EVPN is used for efficient routing and segmentation in large-scale cloud environments. It enables more robust and flexible networking solutions by allowing dynamic route advertisement, enhanced traffic engineering, and seamless integration with existing network infrastructures.

### Tunneling protocols - VXLAN/Geneve

Virtual Extensible LAN (VXLAN) and Generic Network Virtualization Encapsulation (Geneve) are network overlay protocols used in OpenStack and OVN/OVS for tunneling network traffic over existing network infrastructures. VXLAN is widely used for encapsulating Ethernet frames over a UDP tunnel, enabling layer 2 networks to extend over layer 3 networks. Geneve, a newer protocol, offers similar capabilities but with additional flexibility and extensibility. In SCS, VXLAN/Geneve is critical for creating isolated, multi-tenant networks over a shared physical network infrastructure. This encapsulation allows scalable network segmentation, providing secure and efficient communication channels within cloud environments.

## Physical network

The physical network layer is crucial as it provides the foundational infrastructure on which all virtualized network functions are built upon. This layer typically involves various network hardware vendors who supply the physical networking equipment such as switches, routers, and other hardware. These devices are essential for data transmission and routing in a physical setup. Network Operating Systems (NOS) are also a component of the physical network layer. NOS is the software running on network devices, enabling them to perform networking functions and interact with higher-level SDN controllers and applications. In OpenStack Neutron, the ML2 (Modular Layer 2) plugin plays a key role in the physical network layer. ML2 provides an abstraction layer that supports multiple networking mechanisms in a pluggable manner, allowing Neutron to interface with various types of networking hardware and technologies. This plugin architecture ensures that Neutron can work with a wide range of physical networking equipment and configurations, thus enabling flexibility and scalability in the physical network infrastructure of an OpenStack-based SDN deployment.

## Bare metal hosts

Bare metal hosts in the context of OpenStack and SDN play a significant role in providing high-performance, non-virtualized computing resources. These hosts are typically equipped with advanced network interface cards (NICs), such as SmartNICs and Data Processing Units (DPUs). SmartNICs are intelligent network cards that offload processing tasks that would typically be handled by the server CPU. These include functions like traffic shaping, encryption/decryption, and network packet processing. The use of SmartNICs can lead to improved performance and reduced CPU load on the bare metal hosts.

DPUs are an evolution of SmartNICs and are also very common in clouds providing physical servers to users. The difference between SmartNICs is that DPUs usually run their own OS and can be managed independently of the host OS. They are more like computers within a computer. Bare metal servers are directly accessed by the users, which creates a constraint on the SDN network because it should not collide with user workloads. Offloading SDN to the DPU is the best solution for such use cases.

Incorporating SmartNICs and DPUs into bare metal hosts within an OpenStack environment enhances the network's flexibility, efficiency, and performance. This setup is particularly beneficial for workloads that require high throughput, low latency, and secure network communications. As such, bare metal hosts equipped with these advanced NICs are an essential component of modern SDN architectures, particularly in environments where performance and security are critical.

# Common network designs

Below we dive deeper into several common network designs used for SCS/OpenStack deployments.

## VLANs

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/VLANs_network_design.png" @path %}">
    {% asset 'blog/VLANs_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

VLANs are the simplest and most popular design for small operators that are just starting to use OpenStack. 

This type of network leverages VLANs between network switches and servers. Each tenant network is assigned its own VLAN. User workloads like VMs and containers on the server are bound to a VLAN by OVS. Neutron orchestrates the process of creation and management of tenant networks both on the network plane (underlay network) and on the servers. It uses ML2 to provision VLANs on the network switches and delegates to OVN/OVS the binding of the virtual device to the VLAN on the server.

Operators have the option to either pre-provision all VLANs ahead of time so that when a new tenant network appears it can be attached to an existing VLAN without needing to talk to the network devices again. The alternative is to use ML2 to dynamically configure new VLAN before each tenant network is created.

### Pros

- This kind of network is easy to implement. It can be simplified even further by pre-provisioning all VLANs on the physical network thus eliminating the need for ML2. It is a good approach for test beds and small deployments.

### Cons

- Most notably, VLANs don't scale well. This is due to a theoretical limit of 4096 VLANs on each network switch. A more realistic limit would be about 100 OpenStack tenants for a single cloud network. This is a more practical limit based on real world experience.
- The approach is also very fragile. A single VM can break the whole network, thus exposing a huge blast radius. Also, network switches are notorious for being able to persist VLAN configuration. If a switch goes down, its configuration must be replayed after boot-up which is a process leading to significant downtimes.
- Another drawback, which we see is the involvement of the physical network to support the SDN. For each new tenant network in OpenStack, new VLANs must be provisioned. Even in the pre-provisioned scenario, the VLANs must still exist in the underlay, which eventually becomes a bottleneck.

## Network-centric SDN

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/Network_centric_network_design.png" @path %}">
    {% asset 'blog/Network_centric_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

This network design employs a more network-centric approach by implementing most SDN functionalities within the physical network. The key point is that some kind of tunneling protocols like VXLAN or Geneve are used to encapsulate network packets and transport them over the network. In a spine-leaf topology, the leaf or ToR will terminate VXLAN endpoints. For the control plane, BGP (EVPN) is used to transmit layer 2 addressing information between switches.

On the server side, a regular VLAN is provisioned from the ToR switch for each tenant network. Since not all tenant networks are needed on each ToR switch, this design scales better than pure VLANs. Also, no VLANs are used between the switches if the underlay is layer 3.

### Pros

- This kind of network is more scalable, easily handling up to 1000 OpenStack tenants. It is also more stable and resilient to change, because of the smaller blast radius.
- Since all SDN is offloaded to the physical equipment, server CPUs are not doing any encapsulation/decapsulation and are free to serve the users. Heavy data plane processing is done on dedicated network hardware, which has been optimized for this task. Also, no SmartNICs or DPUs are needed on the servers, which is more cost efficient.

### Cons

- Since this is a network-centric approach, the network is still very much involved in the SDN. Physical device limits shown before like persisting  switch configuration still apply. 
- This approach is also more complex than pure VLANs because it requires the network to run routing protocols like BGP and BFD. Neutron still needs to talk the switches via ML2.
- Importantly, traffic between tenant networks (east/west and north/south) is routed via the network nodes, which can become a choke point. So while being better for scalability, this design still has limitations for very large deployments.

## Server-centric SDN

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/Server_centric_network_design.png" @path %}">
    {% asset 'blog/Server_centric_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

With the server-centric network design, SDN software features are implemented on the servers and not on the network equipment. Tunneling protocols like VXLAN have terminating endpoints on the servers and the addresses for those endpoints are discovered via control plane protocols like BGP/EVPN. Also, encapsulation/decapsulation and crypto processing are done on the server.

This design reduces reliance on the physical network to carry out SDN-related tasks. The only requirement for the underlay is that it must be Layer 3 and run BGP to enable server-centric SDN. 

Because of the limited involvement of the physcal network, this design scales very well. The downside, however, is that datapath processing is performed on the server. An example of such processing is VXLAN encapsulation/decapsulation. If no DPU or SmartNIC exists on the server, this logic runs on the CPU, which can negatively impact its performance. It is recommended to deploy servers running SmartNICs to help with data-plane performance.

### Pros

- very scalable
- very efficient datapath routing (ingress/egress)
- simple network underlay
- no network orchestration in OpenStack

### Cons

- complex server
- might require SmartNICs and DPUs to offload server CPU
- must run routing protocols in the server

## Hybrid - SDN on both servers and switches

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/Hybrid_network_design.png" @path %}">
    {% asset 'blog/Hybrid_network_design.png' class="figure-img w-100" %}
  </a>
</figure>

A variation of the server-centric design, the hybrid network supports bare metal nodes, which are allocated to single users. Since the user has full access to the OS of the server, the SDN functionality cannot be deployed alongside applications, since SDN is managed by the service provider. We have two valid options for deploying SDN components in such network:

- dedicated customer switch, attached to a single bare metal node
- a DPU card attached to the bare metal node

SmartNIC is not a good solution, because it is more tightly coupled to the host node and exposed to the end user. DPUs and switches can be  independently managed by the provider. This separation helps avoid collision between network infrastructure and user workloads.

# Solutions for better SDN scalability

In our pursuit to enhance the scalability and performance of SDN networking within Sovereign Cloud Stack (SCS), we have explored several approaches. We focus on leveraging cutting-edge network designs and technologies such as SONiC to meet the growing scalability demands of modern network infrastructures.

## Network design - VXLAN on Servers

For scenarios that utilize a "VXLAN on Servers" network design, we emphasize the use of SmartNICs and Data Processing Units (DPUs) to significantly improve the data plane performance characteristics of the network.

### SmartNICs and DPUs

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/nvidia-bluefield-3-dpu-3c33-d.jpg" @path %}">
    {% asset 'blog/nvidia-bluefield-3-dpu-3c33-d.jpg' class="figure-img w-100" %}
  </a>
</figure>

SmartNICs and DPUs play a crucial role in boosting packet processing speeds within the network. SmartNICs are particularly advantageous for virtual machines (VMs), offering tunneling encapsulation/decapsulation and encryption features essential for SDN protocols. By offloading routing and SDN protocol tasks to the server, SmartNICs enhance CPU performance and offer cost-saving benefits. 

On the other hand, DPUs are ideally suited for environments where bare metal servers are directly accessed by end-users. Representing the next evolutionary step beyond SmartNICs, DPUs offer the distinct advantage of being managed independently by the network operator, separate from user control. Within SCS, we provide the essential infrastructure and configuration capabilities, enabling users to effortlessly set up and manage SmartNIC and DPU features on their networks.

## Network design - VXLAN on Switches

When SDN protocols are implemented directly on network switches, our approach involves exploring the use of SONiC alongside enhancements in tooling and automation to scale effectively.

### SONiC

Our strategy includes bolstering support for SONiC, a powerful open-source network operating system that enables network scalability and flexibility.

### Tooling - Automating SONIC rollout and configuration

We are committed to enhancing tooling, configuration, and documentation to facilitate the adoption of this network architecture in SCS. This includes improvements in OSISM and Kolla Ansible, along with the integration of Netbox. Netbox serves as the source of truth, allowing for the generation of initial roll-out configurations for OSISM and Kolla Ansible. Additionally, we aim to integrate observability and monitoring for SONiC-based network equipment into SCS, leveraging SONiC's existing observability features.

## Physical network

Our efforts extend to improving the dynamic configuration of the physical network from OpenStack. This involves exploring the existing ML2/network-generic-switch driver and expanding its capabilities to support VXLAN and Geneve. We are also examining other drivers/plugins and the potential for developing a new SCS plugin for Neutron. Enhancements related to SCS in SONiC can be packaged independently and installed atop any commercial or community version of SONiC.

## SDN stack

A notable challenge within the OpenStack network nodes is the bottleneck caused by the OVN (Open Virtual Network) control plane software. A potential solution is to migrate the OVN control plane to SONiC. It would allow the OVN control plane to operate in a distributed fashion, leveraging multiple existing SONiC devices within the network for enhanced performance. However, a potential drawback is the resource intensity of OVN, which could strain the limited resources on SONiC devices. Our approach includes carefully evaluating these considerations to ensure a balanced and efficient SDN stack implementation.

