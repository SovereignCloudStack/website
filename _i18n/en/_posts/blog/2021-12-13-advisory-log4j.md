---
layout: post
title:  "Sovereign Cloud Stack Security Advisory log4j"
author: "Kurt Garloff"
avatar: "/assets/images/kgarloff.jpg"
---

_(By Christian Berendt, Kurt Garloff, Felix Kronlage-Dammers)_

## The vulnerability

On Fri, 2021-12-10, a design issue in the very popular Java library log4j
was reported and assigned [CVE-2021-44228](https://www.lunasec.io/docs/blog/log4j-zero-day/)
with a CVSS score of 10, which is the highest
possible score and thus means that this is a very critical vulnerability.
In short, log4j interprets strings that are being submitted to it
causing lookups via the JNDI interface (intended e.g. to do LDAP name resolution).
If attackers can cause log4j to log attacker controlled strings, these can be used
to trigger these lookups and cause arbitrary java code to be loaded and
executed. This can be used to gain access to the
application that uses log4j and the container/VM that the application
is running in. As log4j is so popular, many Java applications are
affected. At this point in time, all log4j versions prior to
log4j2-2.15(-rc2) are affected.

Our German readers might want to read the excellent summary in the
[BSI advisory](https://www.bsi.bund.de/SharedDocs/Cybersicherheitswarnungen/DE/2021/2021-549032-10F2.pdf?__blob=publicationFile&v=3).

## Usage of log4j in SCS

The main components of Sovereign Cloud Stack do not use Java.
However, there are Java tools used at a few places:

1. Keycloak (Identity broker)
2. Nexus (Mirror manager)
3. Elasticsearch (Log analysis tool)

Neither [keycloak](https://github.com/keycloak/keycloak/discussions/9078)
nor nexus are affected by the log4j vulnerability.

However, Elasticsearch does use log4j. Elasticsearch is rolled out in a
container on the SCS compute nodes by default in SCS deployments to allow for
log analysis.

## Potential impact

Normal users do not interact with the Elasticsearch functionality in SCS;
only operators have access to it. An issue that can be abused by operators
is not a serious threat to SCS environments, as in all practical setups,
the operators have more privileges to affect the environment than they
could gain by exploiting vulnerabilities in Elasticsearch. This might only
be different in environments with very large operational teams and a very
fine-grained operational access role model.

However, we can at this point not exclude the possibility that a name
controlled by the user (such as the name from a resource at OpenStack
or Kubernetes level) gets logged and later on processed by ElasticSearch
and logged again via log4j. If so, a user could cause undesired actions
within the ElasticSearch container. If a potential
attacker could in addition find another exploit to escape the container
confinement, he could take over the SCS deployment.

## Mitigation and fix

Until a new version of the Elasticsearch container that uses a fixed
log4j is available, we recommend applying the following change:

1. Change the configuration repository.
   In `environments/kolla/configuration.yml`, add `-Dlog4j2.formatMsgNoLookups=true` to the JVM
   startup paramters:

      ```
      {% raw  %}es_java_opts: "-Dlog4j2.formatMsgNoLookups=true {% if es_heap_size %}-Xms{{ es_heap_size }} -Xmx{{ es_heap_size }}{%endif%}"{% endraw %}

      ```

2. Roll out the changes:
    * If you are *not* using Celery: 
     ```
     osism-manager configuration
     ```
    * If you are using Celery:
     ```
     osism apply configuration
     ```

3. (Re)deploy Elasticsearch:
    * If you are *not* using Celery:
     ```
     osism-kolla deploy elastisearch
     ```
    * If you are using Celery:
     ```
     osism apply elasticsearch
     ```

This causes log4j to no longer interpret the input in ways that lookups
can be triggered and thus reliably avoids the vulnerability. Please note that
this setting `log4j2.formatMsgNoLookups` is only available in 
log4j2 >= 2.10.0, which is fortunately the case in the Elasticsearch container.

When a new Elasticsearch container built with the fixed log4j (2.16 or better 2.17+)
becomes available, we'll issue a new advisory that describes the deployment of the
new container.

## Update 2021-12-21: Fix still valid

Meanwhile, two more security issues around log4j have been reported: 
[CVE-2021-45046](https://www.whitesourcesoftware.com/resources/blog/log4j-vulnerability-cve-2021-45046/)
and [CVE-2021-45105](https://www.whitesourcesoftware.com/resources/blog/log4j-vulnerability-cve-2021-45105/). ]
The former is a context lookup vulnerability (as a variation to the JNDI
lookup vulnerability) while the latter is a Denial of Service attack by
causing an infinite recursion on the context lookup.

We have checked that the recommended setting `log4j2.formatMsgNoLookups=true`
is still fully mitigating the issues in our environment.

The `es_java_opts` setting has been configured in the upstream
[OSISM/ansible_defaults](https://github.com/osism/ansible-defaults)
repository meanwhile (commit c84f87a6106dd53d08447ac7d5a24b2677da38f0),
so fresh deployments of SCS testbeds or production environments get
the mitigation automatically. You can validate this by logging in to
one of your compute nodes and checking the jvm parameters in the process
list (elastic search container).

## Sovereign Cloud Stack Security Contact

Please contact the SCS project management team at 
[project at scs dot sovereignit dot de ](mailto:project@scs.sovereignit.de)
to ask security questions or report security issues.

## Version history

* Minor update on 2021-12-21, 17:45 CET:
    - Information on new CVEs and workaround still being effective.
    - Update recommended log4j version to 2.17+.
    - Mention the implementation and validation in testbed.

* Minor update on 2021-12-14, 15:45 CET:
    - Remove wrong space in `osism apply elasticsearch`
    - Elsasticsearch is deployed on the compute hosts in typical setups, not the manager node.
    - Mention that lookups are done via JNDI to better connect to other descriptions.
    - Mention that the java parameter is only available on log4j2 >= 2.10, which covers the SCS Elasticsearch.
    - Mention fixed version be better 2.16+.

* Initial release on 2021-12-13, 18:30 CET.

