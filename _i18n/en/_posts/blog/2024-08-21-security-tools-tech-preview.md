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

* Why emphasizing security is important
* Regulatory requirements (regular pentests and audits) for SCS users, CSP
* Offering reports to end-customers a possibility for more transparency in the platform


## Concept and methodology

* Pipeline tools for IaaS
* Pipeline tools for KaaS
* Trivy Operator and export of reports
* DefectDojo for central vulnerability management


## Why security teams benefit from automated pentesting

* Difference SAST and DAST
* Fitting the security tools to the platform increases coverage of potential weak points
    * Example OpenStack APIs
    * Example Kubernetes cluster state


## Implementation details

* Showing the repos and code
* Implementation of pipelines as PoC in Zuul
* Solving long runtimes of the jobs (especially Greenbone)
* Exporting the Trivy Operator reports


## Usage

* How to use the code in your pipeline
* How to use DefectDojo in your team


## Conclusion

* What benefit SCS users have from automated pentests
* Outlook to further addons that are on the road map (e.g. SBOM generation and analysis)

