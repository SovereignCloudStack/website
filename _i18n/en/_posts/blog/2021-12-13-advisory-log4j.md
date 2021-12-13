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
causing lookups (e.g. via LDAP). If attackers can cause log4j to log
attacker controlled strings, this can be used to gain access to the
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
container on the manager node by default in SCS deployments to allow for
log analysis.

## Potential impact

Normal users do not interact with the Elasticsearch functionality in SCS;
only operators have access to it. An issue that can be abused by operators
is not a serious threat to SCS environments, as in all practical setups,
the operators have more privileges to affect the environment than they
could gain by exploiting vulnerabilities in Elasticsearch. This might only
be different in environment with very large operational teams and a very
fine-grained operational access role model.

However, we can at this point not exclude the possibility that a name
controlled by the user (such as the name from a resource at OpenStack
or Kubernetes level) gets logged and later on processed by ElasticSearch
and logged again via log4j. If so, a user could cause undesired actions
within the ElasticSearch container on the manager node. If a potential
attacker could in addition find another exploit to escape the container
confinement, he could take over the SCS deployment.

## Mitigation and fix

Until a new version of the Elasticsearch container that uses a fixed
log4j is available, we recommend applying the following change:

1. Change the configuration repository.
   In `environments/kolla/configuration.yml`, add `-Dlog4j2.formatMsgNoLookups=true` to the JVM
   startup paramters:

      ```
      es_java_opts: "-Dlog4j2.formatMsgNoLookups=true \{% if es_heap_size %\}-Xms{{ es_heap_size }} -Xmx{{ es_heap_size }}\{%endif%\}"
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
     osism apply elastic search
     ```

This causes log4j to no longer interpret the input in ways that lookups
can be triggered and thus reliably avoids the vulnerability.

When a new Elasticsearch container built with the fixed log4j becomes available,
we'll issue a new advisory that describes the deployment of the new container.

## Security Contact

Please contact the SCS project management team at 
[project at scs dot sovereignit dot de ](mailto:project@scs.sovereignit.de)
to ask securty questions or report security issues.
