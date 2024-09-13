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

In today's rapidly evolving cloud landscape, security is paramount. As organizations increasingly rely on cloud infrastructure, the need for robust security measures is more critical than ever. This is especially relevant for users of the Sovereign Cloud Stack (SCS), particularly those in sensitive business areas and larger enterprises, where regulatory requirements often mandate regular penetration tests and security audits.

To enable SCS users to run their own security tests inside their infrastructure, the SCS project conceptualized and implemented tooling for automated penetration testing. With release R7 this component is published as a tech preview and available for testing and experimenting.

Adhering to frameworks such as CIS Controls (formerly CIS18) and the NIS2 Directive is crucial for ensuring that security practices meet industry standards. While automated tools cannot completely replace the need for regular manual pentests, they significantly ease the process of achieving compliance, providing a strong foundation for continuous security monitoring.

Moreover, offering detailed security reports to end-customers can significantly enhance transparency, providing them with confidence in the platform's security posture. This approach not only supports compliance efforts but also builds trust, which is essential in the competitive cloud service provider (CSP) market.

## Concept and methodology

The Automated Pentesting component of SCS introduces a comprehensive pipeline designed to enhance security across various layers of the cloud infrastructure. For Infrastructure as a Service (IaaS), tools like Greenbone Vulnerability Manager (GVM) are integrated to scan for vulnerabilities in OpenStack environments, assisting in meeting security benchmarks. For Kubernetes as a Service (KaaS), the [Trivy Operator](https://aquasecurity.github.io/trivy-operator/latest/) is employed to identify vulnerabilities in container images and the Kubernetes cluster state.

At the time of writing, the IaaS security pipeline consists of the following tools:

* [Naabu](https://docs.projectdiscovery.io/tools/naabu/overview), for port scanning
* [httpx](https://docs.projectdiscovery.io/tools/httpx/overview), for HTTP scanning
* [Nuclei](https://docs.projectdiscovery.io/tools/nuclei/overview), for template-based scans
* [ZAP](https://www.zaproxy.org/) (Zed Attack Proxy, formerly OWASP ZAP), for passive and active vulnerability scans, and
* [Greenbone Vulnerability Manager](https://greenbone.github.io/docs/latest/) (GVM), for in-depth scanning for CVEs and other known vulnerabilities.

As this pipeline focuses primarily on dynamic testing and vulnerability management, it does not include tools specifically dedicated to Static Application Security Testing (SAST). However, some of the tools in the pipeline, such as Trivy, can be configured and customized to generate reports that resemble SAST output by analyzing container images and configurations for known vulnerabilities and security misconfigurations. This flexibility allows teams to tailor the tools to their specific security needs, though dedicated SAST tools would still be beneficial for comprehensive source code analysis.

Trivy Operator’s capability to export detailed security reports is a key feature, enabling teams to have a clear understanding of the security posture of their Kubernetes clusters. Additionally, [DefectDojo](https://www.defectdojo.org/) serves as a central platform for managing vulnerabilities across the entire stack, providing a unified view that aids in prioritizing and remediating security issues. This centralization aligns with best practices recommended by frameworks like ISO/IEC 27001 and the NIST Cybersecurity Framework (CSF).

## Why security teams benefit from automated pentesting

Understanding the difference between SAST and Dynamic Application Security Testing (DAST) is crucial for security teams. While SAST focuses on analyzing source code or binaries for vulnerabilities, DAST involves testing running applications for security issues. The automated pentesting tools in SCS cater primarily to DAST methodologies, ensuring that security teams have comprehensive coverage of live environments.

By integrating these tools into the SCS platform, the coverage of potential weak points is significantly increased. For example, OpenStack APIs can be thoroughly tested for vulnerabilities, ensuring they adhere to CIS benchmarks, while the state of Kubernetes clusters can be continuously monitored in line with NIS2 requirements. These tools do not replace manual pentesting, but they offer ongoing insights that complement regular security assessments, making compliance more achievable and security more robust.

## Implementation details

The implementation of automated pentesting within SCS is designed to be both practical and effective. The code repositories are publicly available, allowing users to review and contribute to the development process. Pipelines have been implemented as a Proof of Concept (PoC) in Zuul, an open-source CI/CD system that is well-suited for complex workflows in large-scale cloud environments.

One of the challenges faced during implementation was the long runtime of certain jobs, particularly those involving GVM. Efforts have been made to optimize these jobs to reduce their impact on overall pipeline performance. The export functionality of Trivy Operator reports has also been streamlined, enabling easier integration with other security tools and processes, as well as long-term storage in S3 or Swift.

## Usage

While the SCS team runs these tools regularly against deployed SCS test environments, the security pipeline is meant to be set up by cloud operators (CSPs) to test the security of their own QA, reference and production deployments. There is no dependency on external systems. This way, potential misconfigurations and security issues are detected before they hit production and before outside threat actors find them.

To utilize the automated pentesting tools in your own pipeline, you can follow the documentation provided in the [IaaS quickstart guide](https://docs.scs.community/docs/operating-scs/components/automated-pentesting-iaas/quickstart) and [KaaS quickstart guide](https://docs.scs.community/docs/operating-scs/components/automated-pentesting-kaas/quickstart). These guides offer detailed instructions on how to integrate the tools into your CI/CD pipeline, ensuring that your infrastructure and applications are continuously tested for vulnerabilities.

DefectDojo can be incorporated into your security operations workflow, providing a centralized platform for vulnerability management. By integrating DefectDojo, your team can more effectively track and prioritize security issues, ensuring that they are addressed in a timely manner and that the organization remains secure and complies with relevant cybersecurity regulations.

For further details, refer to each specific code repository:
- [Security Infra Scan Pipeline](https://github.com/SovereignCloudStack/security-infra-scan-pipeline)
- [Security K8s Scan Pipeline](https://github.com/SovereignCloudStack/security-k8s-scan-pipeline)

## Conclusion

Automated pentesting tools offer SCS users a significant advantage in maintaining a secure and compliant cloud environment. By integrating these tools into their pipelines, users can ensure continuous monitoring and testing of their infrastructure and applications, making compliance more attainable and enhancing transparency for end-customers. While these tools do not entirely replace the need for manual penetration tests, they provide valuable ongoing security insights that complement more in-depth assessments.

Looking forward, the roadmap for SCS includes additional features such as Software Bill of Materials (SBOM) generation and analysis. These upcoming features will further strengthen the platform's security capabilities, offering users even more comprehensive tools to safeguard their cloud environments and maintain compliance with evolving cybersecurity standards.
