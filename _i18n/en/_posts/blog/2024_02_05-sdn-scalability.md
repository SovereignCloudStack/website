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

# The Data-Center network

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/dc-network-architectures.png" @path %}">
    {% asset 'blog/dc-network-architectures.png' class="figure-img w-100" %}
  </a>
</figure>

A modern data center network typically uses a 2-tier spine-leaf network architectures. A more traditional 3-tier architectures are less popular.

In a spine-leaf network, all servers in a rack a connected to a single TOR (top of rack) or Leaf switch. Any of the leaf switches are connected to all spine switches in the layber above, which connect the different racks. There are no connections between the leaf switches, nor between the spine switches on the same tier. This kind of network facilitates scalability by being simpler and much easier to support.

On top of this physical network, also called underaly, all Software Defined Networking (SDN) features are build on top of. The SDN is the virtual network managed by end users and connects VMs, containers and sometimes physical servers. The SDN is entirely virtualized and must be designed and implemented with the physical topology in mind in order to achieve the desired performance, functionality and scalability requirements.

# Overview of SDN in Openstack

Software Defined Networking (SDN) refers to a networking concept where software-based controllers and APIs are used to direct network traffic rather than the networking hardware. In Openstack, SDN networks are used to create and manage user networks for virtual machines and containers on top of physical network infrastructure. Both types of networks are also referred to as underlay (physical) and overlay (SDN). Larger use cases (hyperscalers) and increased number of containerized workloads put stress on the SDN stack.

Openstack Neutron is the main component responsible for networking. It heavily leverages open-source technologies like OVN/OVS and also communicates with the underlay network in order to provide higher level network services to users. ML2 is the Neutron plugin which is responsible for communication with the physical network and it can have multiple drivers each supporting particular hardware/vendor devices. The SDN stack in is distributed where some components run on dedicated network nodes, network devices and on the servers as well. 

When Openstack grows its network must scale with it. There are several aspects when we talk about SDN scalability which depends on the actual network architecture. We dive deeper below, but some important points to consider are SDN bottlenecks (OVN control plane, network node resources), support for number of tenants and networks, and actual dataplane performance. In this post we will explorer those challenges and strategies on how to improve SDN scalability in Openstack/SCS.

## SDN stack

In this section we will take a look at the more software components needed to implement SDN in Openstack.

### Neutron

Neutron is an OpenStack project to provide “network connectivity as a service” between interface devices (e.g., vNICs) managed by other OpenStack services (e.g., nova). It implements the OpenStack Networking API. Neutron is responsible for the centralized management of tenant networks, devices and address allocation. It orchestrates the network, the devices by using plugins and drivers for each particular technology chose in the stack below.

### OVN/OVS

Open Virtual Network (OVN) and Open vSwitch (OVS) are integral components of Neutron's network architecture. OVN provides network virtualization, offering logical network abstractions such as logical switches and routers. It serves as a control plane for OVS, which is a high-performance, multilayer virtual switch. Together, OVN/OVS enable dynamic, programmable network setups, allowing for efficient routing, switching, and bridging of traffic in virtualized environments. Their integration with Neutron facilitates complex networking scenarios, ensuring scalability and flexibility in handling network traffic within OpenStack deployments.

### BGP/EVPN

Border Gateway Protocol (BGP) and Ethernet Virtual Private Network (EVPN) are technologies used in conjunction with Neutron for advanced networking functionalities. BGP is a standardized exterior gateway protocol designed to exchange routing and reachability information among autonomous systems on the internet. EVPN extends BGP to support scalable, multi-tenant layer 2 VPN services. In Neutron, BGP/EVPN is used for efficient routing and segmentation in large-scale cloud environments. It enables more robust and flexible networking solutions by allowing for dynamic route advertisement, enhanced traffic engineering, and seamless integration with existing network infrastructures.

### Tunneling protocols - VXLAN/Geneve

Virtual Extensible LAN (VXLAN) and Generic Network Virtualization Encapsulation (Geneve) are network overlay protocols used in Openstack and OVN/OVS for tunneling network traffic over existing network infrastructures. VXLAN is widely used for encapsulating Ethernet frames over a UDP tunnel, enabling layer 2 networks to extend over layer 3 networks. Geneve, a newer protocol, offers similar capabilities but with additional flexibility and extensibility. In Openstack, VXLAN/Geneve is critical for creating isolated, multi-tenant networks over a shared physical network infrastructure. This encapsulation allows for scalable network segmentation, providing secure and efficient communication channels within cloud environments.

## Physical network

The physical network layer in the SDN stack of OpenStack is crucial as it provides the foundational infrastructure over which all virtualized network functions operate. This layer typically involves various hardware vendors who supply the physical networking equipment such as switches, routers, and other networking hardware. These devices are essential for the actual data transmission and routing in a physical setup. Network Operating Systems (NOS) are also a key component of the physical network layer. NOS is the software running on the network devices, enabling them to perform networking functions and interact with higher-level SDN controllers and applications. In OpenStack, the ML2 (Modular Layer 2) plugin in Neutron plays a vital role in the physical network layer. ML2 provides an abstraction layer that supports multiple networking mechanisms in a pluggable manner, allowing Neutron to interface with various types of networking hardware and technologies. This plugin architecture ensures that Neutron can work with a wide range of physical networking equipment and configurations, thus enabling flexibility and scalability in the physical network infrastructure of an OpenStack-based SDN deployment.

## Bare metal hosts

Bare metal hosts in the context of OpenStack and SDN play a significant role in providing high-performance, non-virtualized computing resources. These hosts are typically equipped with advanced network interface cards (NICs), such as SmartNICs and Data Processing Units (DPUs). SmartNICs are intelligent network cards that offload processing tasks that would typically be handled by the server CPU. This includes tasks such as traffic shaping, encryption/decryption, and network packet processing. The use of SmartNICs can lead to improved performance and reduced CPU load on the bare metal hosts.

DPUs are another key component in bare metal hosts, offering similar functionalities to SmartNICs but with additional OS they can be managed independently of the host OS by the service provider. This makes them ideal for Openstack deployments for physical server as SDN and core network features provided by the data center can be managed centrally without impacting the user. 

Incorporating SmartNICs and DPUs into bare metal hosts within an OpenStack environment enhances the network's flexibility, efficiency, and performance. This setup is particularly beneficial for workloads that require high throughput, low latency, and secure network communications. As such, bare metal hosts equipped with these advanced NICs are an essential component of modern SDN architectures, particularly in environments where performance and security are critical.

# Common network designs

Below we will take a closer look into a common network designs used for Openstack deployments.

## VLANs

![](https://input.scs.community/uploads/0a5e9ce4-a248-4883-855e-671f3b252629.png)

VLANs is the most simple and common design for very small users that are starting to use Openstack. 

This type of network leverages VLANs between network switches and server for the SDN traffic. User workload like VMs and containers on the server are bound to a VLAN usually with OVS. Neutron orchestrates the process of creation and management of user networks both on the network plane (underlay network) and on the servers. ML2 plugin and drivers are used to talk to the network devices and OVN/OVS control plane on the server.

Users have the option to either pre-provision all VLANs ahead of time, so that when new tenant network appears it can be attached to an existing VLAN without needing to talk to the network devices again. The alternative is to use ML2 to dynamically configure new VLAN before each tenant network is created.

### Pros

- This kind of network is easy and simple to implement. It can be further simplified by pre-provisioning all VLANs on the physical network and potentially eliminating ML2. It is a good approach for test-beds and small deployments.

### Cons

- Most notably, VLANs for SDN doesn't scale well. First we have a theoretical limit of 4096 VLANs on each network switch. More realistic limit would be about 100 Openstack tenants.
- The approach is also very fragile. A single VM can brake the whole network, thus exposing a huge blast radius. Also, network switches are notorious for being able to persist VLAN configuration. If a switch goes down, its configuration must be replayed after boot-up which is a process leading to significant downtimes.
- Another drawback, which we see here is the involvement of the physical network which is needed to support the SDN. For each new user network in Openstack, new VLANs must be created and attached to. Even in pre-provisioned scenario, the VLANs must still exist in the underlay, which eventually becomes a bottleneck.

## Network-centric SDN

![](https://input.scs.community/uploads/d5809a20-4b31-44bb-9247-1cad2692cfb3.png)

This network design employs a more network centric approach by implementing most of the SDN functionalities within the physical network devices. The key point is that some kind of tunneling protocol like VXLAN or Geneve is used to encapsulate user network packets and transport them over the network. In a spine-leaf topology, the leaf or ToR will terminate VXLAN endpoints. For the control plane BGP (EVPN) is used to transmit addressing information between switches.

On the server side, a regular VLAN is provisioned to the ToR switch for each tenant network. Since not all tenant networks are needed on each ToR switch, this design scales better than pure VLANs. Also no VLANs are needed between the switches because the underlay is layer 3.

### Pros

- This kind of network is more scalable, easily handling up to 1000 Openstack tenants. It is also more stable and resilient to change, because of the smaller blast radius.
- Since all SDN is offloaded to the physical equipment, server CPUs are not doing any VXLAN encap/decap and are free to server the users. Heavy dataplane processing is done on dedicated network hardware, which has been designed for the job. So no SmartNICs or DPUs are needed on the servers, which is more cost efficient.

### Cons

- Since a network centric approach is used, the network is still very much involved in the SDN. Physical device drawbacks shown before like persisting the switch configuration still apply. 
- This approach is also more complex than pure VLANs, because it requires the network to run routing protocols like BGP and BFD. Neutron still needs to talk the to switches via ML2.
- Importantly traffic between tenant networks (east/west and north/south) is routed via the network nodes, which can become a choke point. So while being a better for scalability, this design still has limitations for very large deployments.

## Server-centric SDN

![](https://input.scs.community/uploads/4be35939-f402-4618-9d87-a0abadee9823.png)

With the server-centric network design, SDN software features are implemented on the servers and not on the network equipment. Tunneling protocols like VXLAN have terminating endpoints on the servers and the addresses for those endpoints are discovered via control plane protocols like BGP/EVPN. Also encap/decap and crypto processing are done on the server as well.

This kind of design greatly reduces reliance on the network to carry out SDN related tasks. The underlay must be Layer 3 and run BGP in order to enable server-centric SDN. There are no further requirements for the underlay. This makes it simple and allows scale.

Because of the limited involvement of the underlay network, this design scales very well. The downside, however, is the datapath processing in done on the server. Example of such processing is VXLAN encapsulation/decapsulation. If no DPU or SmartNIC exists on the server, this logic runs on the CPU, which can negatively impact its performance. Therefore the use of DPU/SmartNICs is very much needed.

### Pros

- very scalable
- very efficient datapath routing (ingress/egress)
- simple network underlay
- no network orchestration in Openstack

### Cons

- complex server
- might require SmartNICs and DPUs to offload server CPU
- must run routing protocols in the server

## Hybrid - SDN on both servers and switches

![](https://input.scs.community/uploads/c6534aa1-99c2-4841-bfd9-8321e9dae5a4.png)


A variation of the server-centric design, the hybrid network support bare metal nodes, which are allocated to single users. Since the user has full access to the OS of the server, the SDN functionality cannot be deployed along side applications, since it is managed by the service provider. Therefore we need to run SDN on some network switches connected to bare metal servers and on other places run SDN directly on the server if they only host VMs. For SDN we have two options:
- dedicated customer switch, attached to a single bare metal node
- a DPU card attached at the bare metal node

SmartNIC is not a good solution here, because it is more tightly coupled to the host node and exposed to the end user. DPUs and switches can be managed independently by the provider, so that the user does not need access to them.

# Our solution

In our pursuit to enhance the scalability and performance of SDN networking within Sovereign Cloud Stack (SCS), we have explored several approaches. Our focus is on leveraging cutting-edge network designs and technologies such as SONiC to meet the growing demands of modern network infrastructures.

## Network design - VXLAN on Servers

For scenarios that utilize a "VXLAN on Servers" network design, we emphasize the use of SmartNICs and Data Processing Units (DPUs) to significantly improve the data plane performance characteristics of the network.

### SmartNICs and DPUs

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

A notable challenge within the OpenStack network nodes is the bottleneck caused by the OVN (Open Virtual Network) control plane software. A promising solution is to migrate the OVN control plane to SONiC. This move would allow the OVN control plane to operate in a distributed fashion, leveraging multiple existing SONiC devices within the network for enhanced performance. However, a potential drawback is the resource intensity of OVN, which could strain the limited resources on SONiC devices. Our approach includes carefully evaluating these considerations to ensure a balanced and efficient SDN stack implementation.

