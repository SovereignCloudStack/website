---
layout: post
title:  "Cluster Stacks"
author: 
- "Janis Kemper"
- "Sven Batista Steinbach"
- "Jan Schoone"
- "Alexander Diab"
---
## Cluster Stacks
With Release 5, the Sovereign Cloud Stack has published a technical preview of the "Cluster Stacks" - a framework that simplifies the productive operation of Kubernetes clusters from the user's perspective and offers transparency regarding the configuration and composition of the cluster's core components.
SCS is thus creating a decentralized and user-oriented alternative to the often non-transparent and non cross-compatible commercial "Managed Kubernetes" offerings.

### Kubernetes - More difficult than it seems
Operating a Kubernetes cluster is in principle not difficult. However, simple Kubernetes clusters generally do not meet the requirements for production operation in terms of stability, security and reliability. A Kubernetes cluster in a production environment requires extensive configuration with regard to important core applications and node images to be, for example, protected against cyber attacks. In practice, a lack of knowledge often has the consequence that companies use unsecured clusters for real workloads, which are at risk from the rapidly increasing number of cyber attacks.
Another frequent problem is the missing test infrastructure, without which updates to production clusters are prone to errors. As a result, clusters are updated only once a year as forced by a no longer supported Kubernetes version.

### Proprietary and intransparent Solutions
Many users therefore either rely on a "Managed Kubernetes" service from an infrastructure provider or, if they operate the Kubernetes environment themselves, on a commercial and therefore usually proprietary product (e.g. OpenShift).
These solutions are usually so specific in terms of configuration and component selection that changing them is extremely time-consuming and resource-intensive. In addition, a hosted "managed" solution is often opaque with respect to structure and function - which creates an additional dependency. It is rarely clear how clusters are structured and which steps a customer still has to carry out independently in order to operate a cluster securely and ready for production. As these steps are different for each provider, migrations or the use of multiple providers are correspondingly difficult.
Depending on the service, the user may have more or less responsibility. This can mean that certain security settings or important components are already built into one service but lacking in another one. Every time a user switches providers, they must therefore take a close look at the details of the product so that they can draw the right conclusions and implement the missing settings and install the missing components themselves.

### Cluster Stacks - The solution for production-ready and simple Kubernetes
This is where the cluster stacks from SCS come in and create a solution in which the structure of a cluster is transparent or completely open-source, even with a "managed" solution, and users can join together in a community to improve the managed solution together with the providers. It is based on the open-source Kubernetes project "Cluster API", which makes it possible to create and operate secure clusters quickly and easily - even on different providers.
Cluster stacks are a concept that combines all the important components of a Kubernetes cluster. The three main components are:
1. Configuration of Kubernetes (e.g. Kubeadm),
2. Core Applications, 
3. Node Images
These three elements are combined in cluster stacks and tested as a whole. a cluster stack is released only if everything works together and an upgrade from the previous version is possible and its function thus is ensured. This avoids the frequent problems that occur when updating Kubernetes clusters.
In addition, the [SCS Cluster Stack Operator](https://github.com/SovereignCloudStack//cluster-stack-operator) simplifies the use of [Cluster Stacks](https://github.com/SovereignCloudStack//cluster-stacks). Together with the cluster API, simple API calls can be used to create new, production-ready clusters or update existing ones.

### Cluster Stacks as Framework
The cluster stacks are a concept that is open to all providers and allows that clusters can be created and managed on the basis of the cluster API. Existing cluster stacks can be further utilized or individually created, e.g. to support additional providers or add specific requirements.
As part of the SCS project, cluster stacks are configured for selected providers and therefore guarantee SCS-standardized use of Kubernetes. Apart from the fact that Cluster API is a prerequisite technology, the cluster stacks have no dependencies.

### Outlook 
The R5 release contains a technical preview of the cluster stacks and the associated operator, as well as a [demo](https://github.com/SovereignCloudStack/cluster-stacks-demo), which allows users to start clusters locally using Docker.
An OpenStack interface for OpenStack will be released in the coming weeks so that the cluster stacks can be used on "real" cloud infrastructure.


