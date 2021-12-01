## Lot 6d

### Kubernetes tooling

To be able to develop and deploy container applications to Kubernetes (k8s)
clusters, some tooling is required. Standard mechanisms shall be provided
for the automated installation of container apps. Tools and workflow
automation are required. Application developer also need the ability
to collect metrics from the application and thus analyze the application's
performance. In case of errors, these should be traceable across the
various layers of the platform.

### IaC Tooling

Together with operations colleagues, application developers work together
(as DevOps teams) to deploy applications to the (virtual) infrastructure
in an automated manner. This happens on a daily basis during test integration
runs and somewhat less often to provide new production deployments of the
application -- this happens using the same automation. The automated
management of the (agile) infrastructure with software configuration is
called Infrastructure-as-Code and often happens with tools like
terraform or ansible. The job of the SCS project is to ensure that
these tools work flawlessly on SCS environments. This support needs to
be assured via automated test procedures.

