---
layout: post
title: "Delving into the Technical Depths of Intel-SA-00950 and AMD Cachewarp Vulnerabilities"
author:
  - "David Rodríguez"
avatar:
  - ""
about:
  - ""
image: ""
---

## The Evolving Landscape of Security Vulnerabilities

In the ever-evolving realm of cybersecurity, new vulnerabilities are constantly being discovered and exploited by malicious actors. These vulnerabilities can exploit various aspects of computing systems, ranging from hardware architecture to software implementations. Past August, We already talk about [CPU leaks](https://scs.community/2023/08/29/new-cpu-leaks/) which supposed a risk for providers and users of SCS clouds.

Recently, two critical vulnerabilities, namely Intel-SA-00950 and AMD CacheWarp, have emerged, posing significant threats to system security and data integrity.

## Intel-SA-00950: Unveiling the underlying mechanism

At the heart of Intel-SA-00950, tracked as CVE-2023-23583, lies a a flaw in the implementation of the Fast Repeat MOVSB instruction (*rep movsb*), also known as **FRMS**, in Intel's IPUs. FRMS is a specialized instruction designed to efficiently copy data between x86 memory locations. However, the vulnerability lies in the way FRMS handles certain instruction sequences that contain a mix of FRMS and other instructions.

### The Root Cause: FRMS Handling of Branching Instructions

The vulnerability lies in the interaction between FRMS and conditional (branching) instructions. When a sequence of instructions comprising FRMS and branching instructions is executed, FRMS may misinterpret the branching instructions, leading to unintended activation of IPU functionality.

This unintended activation, in turn, triggers a cascade of events that can  manifest in various ways, including:

- **OOB Memory Accesses**: FRMS, under the influence of the misinterpreted branching instructions, may access memory locations that are not directly accessible to the executing code. This can lead to the disclosure of sensitive data from privileged memory regions.

- **Data Corruption**: The unintended activation of IPU functionality can disrupt the normal operation of the processor, leading to data corruption and unpredictable behavior.

- **System Malfunction**: In extreme cases, the corruption of critical data or the disruption of IPU functionality can cause system crashes or other forms of malfunction, effectively denying service to legitimate users.

Our team performed several local tests on systems with affected processors, leading in all of them to BSODs and system crashes, even with the attacks being launched from virtual machines running on the host.

### Affected Processor Families and Models

The following Intel processor families and models are affected by Intel-SA-00950:

- Intel Core processors, including Core i7, Core i5, Core i3, and Celeron

- Intel Xeon processors

- Intel Atom processors

- Intel Pentium processors

### Severity Classification and Exploit Difficulty

The Intel-SA-00950 vulnerability is considered to be of high severity, with a CVSS score of 8.8 (High). This means that the vulnerability is considered to be very serious and could have a significant impact on affected systems.

However, it is true that exploiting it is considered to be moderately difficult due to the specific conditions that need to be met. An attacker would need to have physical access to the affected system and be able to run privileged code. Additionally, the exploit would need to be carefully crafted to avoid detection by security measures.

Additionaly, as per the date of writting this post, the vulnerability is not believed to be actively exploited in the wild.

## AMD Cachewarp Vulnerabilities: Compromising Encrypted Virtual Machines

AMD Cachewarp vulnerability, tracked as CVE-2023-20592, is a software fault attack that targets AMD's Secure Encrypted Virtualization (SEV) technology. SEV is a hardware-based virtualization technology that allows multiple virtual machines (VMs) to run on a single AMD EPYC™ CPU while preventing unauthorized access between them.

The CacheWarp vulnerability originates from a design flaw in the way SEV handles cache evictions. As a CPU processes data, it stores frequently accessed information in its cache, a high-speed memory that facilitates faster retrieval. When a cache line, a small unit of data, is no longer needed, it is evicted from the cache and marked as invalid. The eviction information is stored in a specific memory location.

Thee vulnerability allows an attacker to overwrite this eviction information with false data, which deceives the CPU into believing that the evicted cache line is still valid, causing it to reload the evicted data from memory, even if it has been modified by the attacker.

### Leakage and Control: The Perils of CacheWarp

The CacheWarp vulnerability can be exploited in two primary ways:

- **Leakage of Sensitive Information**: By modifying the data in the reloaded cache line, the attacker can potentially gain access to sensitive information stored within the SEV-protected VM. This can have devastating consequences for organizations that rely on SEV to safeguard sensitive data.

- **Gaining Control of the VM**: If the attacker manages to modify critical control data within the SEV-protected VM, they could gain full control of the VM, enabling them to execute arbitrary code and potentially disrupt operations.


### Affected Processor Families and Models

The following AMD processor families and models are affected by CacheWarp:

- 1st Gen AMD EPYC™ Processors (SEV and SEV-ES)

- 2nd Gen AMD EPYC™ Processors (SEV and SEV-ES)

- 3rd Gen AMD EPYC™ Processors (SEV, SEV-ES, SEV-SNP)

### Severity Classification and Exploit Difficulty

The CacheWarp vulnerability is considered to be of moderate severity, with a CVSS score of 5.3 (medium). 

Exploiting it is considered to be relatively easy due to the fact that it only requires privileged access to the system. However, it is important to note that the exploit would need to be carefully crafted to avoid detection by security measures.

As per the date of writting this post, the vulnerability is not believed to be actively exploited in the wild.

## Mitigation and SCS flavor policy

Regarding the Intel-SA_00950 Linux distributors have published updated microcode called `intel-microcode` and updated kernels in the past weeks.

For the Ubuntu 22.04 LTS distribution normally used on SCS installations, the updates to the Intel microcode are described in [USN-6485-1](https://ubuntu.com/security/notices/USN-6485-1).

AMD has released software patches to address the Cachewarp vulnerabilities in SEV-ES and SEV-SNP environments. However there is no mitigation available for first and second generations of EPYC™ processors, this is "Zen 1" (codename "Naples") and "Zen 2" (codename "Rome"). The µcode patch is being deployed in two ways, as a standalone patch with an updated SEV firmware image and/or as part of a platform initialization (PI) package update. The updates on the microcode and firmware are described in [AMD INVD Security Advisory](https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3005.html).

SCS requires providers of SCS-compatible IaaS to deploy fixes that are available upstream within a month of the availability.
This is mandated by the [SCS flavor naming standard](https://docs.scs.community/standards/scs-0100-v3-flavor-naming#complete-proposal-for-systematic-flavor-naming)
-- by not using the `i` (for insecure) suffix, they commit to keeping their compute hosts secured against such flaws by deploying the needed microcode, kernel and hypervisor fixes and mitigations.

## Conclusion
Intel-SA-00950 and AMD Cachewarp vulnerabilities highlight the importance of vigilance and proactive cybersecurity measures. By promptly addressing these vulnerabilities and implementing preventative strategies, We can safeguard our systems, data, and users from potential security threats.

## References

* [Intel-SA-00950 Security Advisory](https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa-00950.html)
* [Intel-SA-00950 Affected Products](https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html)
* [Reptar](https://lock.cmpxchg8b.com/reptar.html)
* [AMD CacheWarp](https://cachewarpattack.com/)
* [AMD CacheWarp Proof-of-concept implementation](https://github.com/cispa/CacheWarp)
