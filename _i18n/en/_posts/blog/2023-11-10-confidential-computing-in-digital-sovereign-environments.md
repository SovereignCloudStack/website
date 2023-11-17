---
layout: post
title:  "Confidential Computing in digital sovereign environments"
category: tech
author:
  - "Markus Leberecht"
  - "Felix Kronlage-Dammers"
avatar:
  - "fkr.jpg"
  - "markusleberecht.png" 
about:
  - "fkr"
  - "mleberec"
---

# Confidential Computing in digital sovereign environments

## Why is confidential computing anticipated

Protecting data is at the heart of any digital sovereignty discussion. Traditional controls to achieve this rely on the encryption of data assets with keys managed such that sovereignty goals can be achieved. This bases data protection on proper key management based on a consistent role understanding and access management. So far, so common...

Throughout a data asset's life cycle, multiple and well-understood methods exist for protecting data at rest, i.e. when stored, such as drive, file, and object encryption, and for protecting data in transit on the wire via e.g. IPsec or TLS. Up to recently, however, when data is being processed, it was required to be in cleartext, as was the code being executed to process it. Confidential Computing sets out to solve this: a Trusted Execution Environment (TEE) in the CPU gets established that protects and isolates code and data at runtime. Implemented as part of a processor's memory map, encryption is again used to keep code and data within such as TEE confidential. Only after reading the encrypted memory lines into the processor package does such data get decrypted so that it can be processed. Processor business logic ensures that encryption keys are only managed by the tenant and cannot be utilized by other tenants nor by system software or platform administrators. 

This execution model helps to separate duties between a tenant and a platform owner that do not belong to the same organization - a model all too common in public cloud computing. Going one step further, typical Confidential Computing implementations also allow any external party to get a cryptographic proof of a TEE's content at runtime via a remote attestation mechanism. In such a case a challenged TEE's CPU would reply with a signed current measurement (hash) of the TEE's memory map as well as a patch level indicator for the underlying server platform's critical firmware, allowing the relying party to validate these values against expectations before sharing secrets with the TEE. 

Overall, Confidential Computing, when implemented well, can be utilized to enforce compliance needs and, as such, helps to amplify the sovereignty posture of digital services based on it. 

## Technology explained

Current x86 Confidential Computing technologies differ in the way they support the common spectrum of deployment artifacts used in cloud stacks. 

a) Process-based TEEs: Intel Software Guard Extensions (SGX)

Intel SGX was the first Confidential Computing technology on the market. It appeared with support for size-limited TEEs (up to 256 MB), so called Secure Enclaves, in Intel's client architectures of the Skylake microarchitecture and following, and supported an attestation method based on the Enhanced Privacy ID (EPID). This initial version of SGX was since discontinued. 

Today's version of Intel SGX has improved performance, supports Enclave sizes of up to 1 TB in 2 socket system, and features a scalable attestation protocol based on ECDSA signatures. It has been on the market since the Xeon Scalable Processor of the 3rd generation, codename Icelake. 

An SGX Enclave effectively encapsulates code and data that make up a process. Code entry and exit from such an enclave are done explicitly through call gates, while neither operating system calls nor devices are directly supported within the enclave and thus have to be proxied through call gates. In order to utilize existing applications within such an Enclave, library operating systems such as Gramine (https://gramineproject.io) are utilized to implement a largely Linux-compliant ABI to an application and can help to even run container processes within the TEE (Gramine Shielded Containers, https://gramine.readthedocs.io/en/stable/gsc-installation.html).

Attestation of such an SGX Enclave will measure the Enclave's current memory content and provide back the security version of the platform's firmware setup in addition. A simplified sequence for SGX ECDSA-based attestation is shown in the following animation:  

<figure class="figure mx-auto d-block" style="width:100%">
    {% asset 'blog/cc/JM-ecdsa-attestation-sequence.gif' class="figure-img w-100" alt="Intel SGX ECDSA Attestation"%}
    <figcaption>Intel SGX ECDSA Attestation</figcaption>
</figure>


Since Linux kernel 5.13, a system with SGX enabled will be supported by the mainstream kernel without additional configuration in all Linux distributions. On bare metal and within KVM/Qemu-based VMs, SGX memory - the so-called Enclave Page Cache - will be accessible to code utilizing SGX instructions. Up to date versions of qemu (>=6.2) and libvirt (>=8.10) support using SGX within virtual machines.

Being on the market for this extended time, SGX has been researched well and [vulnerabilities found](https://en.wikipedia.org/wiki/Software_Guard_Extensions#List_of_SGX_vulnerabilities) have been [fixed](https://www.intel.com/content/www/us/en/security-center/default.html) either through microcode updates or microarchitectural changes that were applied along with SGX' Trusted Compute Base Recovery (TCB-R) process which allows to gracefully handle enclave version and patch level changes in its attestation framework. For more information on both SGX attestation and TCB Recovery please see this page on [SGX attestation technical details](https://www.intel.com/content/www/us/en/security-center/technical-details/sgx-attestation-technical-details.html).

b) VM-based TEEs: Intel TDX And AMD SEV

While application-based TEEs like SGX enclaves minimize the trust boundary around confidential data and thus help to keep attack surfaces small, it requires explicit effort to convert existing artifacts, whether through re-linking or through application refactoring. Technologies such as Intel Trust Domain Extensions (Intel TDX) and AMD Secure Encrypted Virtualization (AMD SEV) in their respective variants directly support virtual machines to be deployed as TEEs. 

The simplicity of the deployment model comes at some costs, though: this model relies on hypervisor support and by definition cannot be implemented as a bare-metal deployment method. Also, attestation of such a VM-based TEE will only be able to reasonably measure the static portions of a deployed VM image as typical memory sizes might be a barrier for timely hashing, and because of a VM's operating system dynamicism will hardly find a single definable state to compare against a golden value. For these reasons, remote attestation of VM TEEs typically only focuses on the static boot stack and will rely on e.g. Linux' Integrity Measurement Architecture to protect an application-defined set of critical files against unwanted changes. 

c) When to use what?

Based on the previous characteristics, application isolation via process-based TEEs leans itself more to highly critical applications and code that can be
easily standardized on. Due to projects like Gramine Shielded Containers, a dockerized version of standard open-source components can be made to be run with
SGX support and deployed through Kubernetes with limited effort. Kubernetes Node Feature Discovery will recognize SGX and can be used in a cluster to identify and orchestrate towards SGX-supporting nodes. There also exist libraries of pre-tested docker images for SGX-enabled versions of typical open-
source components, such as NGINX, Vault, and others. (See e.g. https://github.com/enclaive or https://github.com/gramineproject/examples.) Projects like Marblerun (https://github.com/edgelesssys/marblerun) can then help to tie together a multi-container deployment with a single attestation process. 

If a complex application stack exists as a virtual-machine deployment, it naturally leans itself more towards VM-based TEEs. Note that here the application stack should be redeployed on top of an image base that contains paravirtualized TDX or SEV guest support (e.g. adjusted VM firmware) as simply re-launching an existing qcow image within a TEE would not yield the desired outcome.  

An easy way to compare the security posture of different Confidential Computing deployment variants is shown in the following diagram.

<figure class="figure mx-auto d-block" style="width:100%">
    {% asset 'blog/cc/trusted-boundary-elements.png' class="figure-img w-100" alt="Trusted Boundary Elements"%}
    <figcaption>Trusted Boundary Elements</figcaption>
</figure>

A limiting factor for Confidential Computing in both cases is the use of I/O-based accelerators as the combined execution environment of CPU TEE, I/O communication over PCIexpress, and the accelerator's own TEE cannot be secured at I/O line speed at the time of writing and as such will only form a rather slow combined TEE. 

## From theory to Trusted Execution Environments in SCS

For SCS to embark on the support for Confidential Computing, SGX presents itself as the most mature and deployment-proven due to its length of availability. In order for the SCS IaaS reference implementation to be able to support SGX Enclaves the support for SGX must therfore be present in OpenStack.

With the [Secured Cloud Management Stack](https://github.com/intel/secured-cloud-management-stack/) (SCM) a lot of work has been done by Intel to bring Trusted Execution Environments to OpenStack. In order to make this accessable on top of SCS it must become part of upstream OpenStack. Through the various tenders run by the Sovereign Cloud Stack project bringing technoloy upstream is being funded and a while ago it has been concluded to tackle the upstreaming of the Intel patchset as part of our [tender package 01](https://scs.community/tenders/lot1).

The work is aligned in the Team IaaS and is outlined in [a corresponding epic](https://github.com/SovereignCloudStack/issues/issues/39).

Aside from the funding through the tender 01 the effort is supported by Intel providing the corresponding hardware.

Once support has landed in upstream OpenStack proper testing needs to be added in order to assure 

## Moving upwards from the metal

Looking forward a lot of the interesting parts are happening upwards from the IaaS - cloud-native workloads such as the [Eclipse XFSC - Cross Federation Services Components](https://projects.eclipse.org/projects/technology.xfsc) could greatly benefit from confidential computing.

## What are the XFSC and how do they benefit from confidential computing

Eclipse XFSC (Cross Federation Services Components) develops the software components necessary to set up a federated system that interconnects several participants in a data and service infrastructure with each other, aiming to develop new data-driven services and innovative products. Such ecosystems consist of joined interconnected data and infrastructure ecosystems, aggregated in so-called Federations that are individually orchestrated and operated with the help of Federation Services, part of Gaia-X.

It consists of several components (mainly microservices) enabling federations in data ecosystems and providing interoperability across federations.

These services empower federations to authenticate and authorize participants in a federation, for example via credential validation, and cover technology functionalities to ensure a consistent level of trust between all Participants of a federation.

* Authentication & Authorization Service (AAS)
* Personal Credential Manager (PCM)
* Organization Credential Manager (OCM)
* Trust Services (TRU)
* Notarization Service (NOT)

<figure class="figure mx-auto d-block" style="width:100%">
    {% asset 'blog/cc/xfsc-architecture.png' class="figure-img w-100" alt="XFSC Architecture Overview"%}
    <figcaption>XFSC Architecture Overview</figcaption>
</figure>

The architectural overview shows the various microservices involved in the XFSC. Confidential Computing for the Organizational Credential Manager (OCM) allows to attest running code of OCM before sending secrets and enables to keep secrets confidential while processing further activities in XFSC.
