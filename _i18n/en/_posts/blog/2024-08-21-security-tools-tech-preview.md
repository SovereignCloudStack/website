---
layout: post
title: "Tech Preview: Automated pentesting tools in SCS"
author:
  - "David Rodríguez"
  - "Antonio Juanilla Hernandez"
  - "Dominik Pataky"
avatar:
  - "90n20"
  - "bitkeks"
about:
  - "90n20"
  - "bitkeks"
---

## Motivation

In today's rapidly evolving cloud landscape, security is paramount. As organizations increasingly rely on cloud infrastructure, the need for robust security measures is more critical than ever. This is particularly true for users of the Sovereign Cloud Stack (SCS), where regulatory requirements mandate regular penetration tests and security audits. Frameworks such as CIS Controls (formerly CIS18) and the NIS2 Directive impose stringent security standards, requiring organizations to proactively manage and mitigate cybersecurity risks.

The ability to consistently conduct thorough pentests ensures that the SCS platform remains compliant with these regulations, thereby reducing the risk of breaches and ensuring the integrity of the system. Furthermore, offering detailed security reports to end-customers can significantly enhance transparency, providing them with confidence in the platform's security posture. This approach not only fulfills compliance obligations but also establishes trust, which is crucial in the competitive cloud service provider (CSP) market.


## Concept and methodology

The Automated Pentesting component of SCS introduces a comprehensive pipeline designed to enhance security across various layers of the cloud infrastructure. For Infrastructure as a Service (IaaS), tools like Greenbone Vulnerability Management (GVM) are integrated to scan for vulnerabilities in OpenStack environments, ensuring compliance with security benchmarks such as the CIS Controls. For Kubernetes as a Service (KaaS), the Trivy Operator is employed to identify vulnerabilities in container images and the Kubernetes cluster state, in alignment with NIS2 requirements for maintaining the security of critical infrastructure.

Trivy Operator’s capability to export detailed security reports is a key feature, enabling teams to have a clear understanding of the security posture of their Kubernetes clusters. Additionally, DefectDojo serves as a central platform for managing vulnerabilities across the entire stack, providing a unified view that aids in prioritizing and remediating security issues. This centralization aligns with the best practices recommended by frameworks like ISO/IEC 27001 and the NIST Cybersecurity Framework (CSF).


## Why security teams benefit from automated pentesting

Understanding the difference between Static Application Security Testing (SAST) and Dynamic Application Security Testing (DAST) is crucial for security teams. SAST focuses on analyzing source code or binaries for vulnerabilities, while DAST involves testing running applications for security issues. The automated pentesting tools in SCS cater to both these methodologies, ensuring that security teams have comprehensive coverage.

By integrating these tools into the SCS platform, the coverage of potential weak points is significantly increased. For example, OpenStack APIs can be thoroughly tested for vulnerabilities, ensuring they adhere to CIS benchmarks, while the state of Kubernetes clusters can be continuously monitored in line with NIS2 requirements, ensuring that any security gaps are promptly addressed.


## Implementation details

The implementation of automated pentesting within SCS is designed to be both practical and effective. The code repositories are publicly available, allowing users to review and contribute to the development process. Pipelines have been implemented as a Proof of Concept (PoC) in Zuul, an open-source CI/CD system that is well-suited for complex workflows in large-scale cloud environments.

One of the challenges faced during implementation was the long runtime of certain jobs, particularly those involving Greenbone Vulnerability Management. Efforts have been made to optimize these jobs to reduce their impact on overall pipeline performance. The export functionality of Trivy Operator reports has also been streamlined, enabling easier integration with other security tools and processes, thereby ensuring ongoing compliance with regulatory requirements like CIS Controls and the NIST CSF.


## Usage

To utilize the automated pentesting tools in your own pipeline, you can follow the documentation provided in the Quickstart guide. This guide offers detailed instructions on how to integrate the tools into your CI/CD pipeline, ensuring that your infrastructure and applications are continuously tested for vulnerabilities, in line with compliance standards such as CIS Controls and NIS2.

DefectDojo can be incorporated into your security operations workflow, providing a centralized platform for vulnerability management. By integrating DefectDojo, your team can more effectively track and prioritize security issues, ensuring that they are addressed in a timely manner and that the organization remains compliant with relevant cybersecurity regulations.


## Conclusion

Automated pentesting tools offer SCS users a significant advantage in maintaining a secure and compliant cloud environment. By integrating these tools into their pipelines, users can ensure continuous monitoring and testing of their infrastructure and applications, meeting regulatory requirements and enhancing transparency for end-customers.

Looking forward, the roadmap for SCS includes additional features such as Software Bill of Materials (SBOM) generation and analysis. These upcoming features will further strengthen the platform's security capabilities, offering users even more comprehensive tools to safeguard their cloud environments and maintain compliance with evolving cybersecurity standards.
