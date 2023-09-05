---
layout: post
title: "Progress: OpenStack API access with OpenID Connect in Sovereign Cloud Stack"
author:
  - "Arvid Requate"
avatar:
  - "arequate.jpg"
about:
  - "arequate"
---

As reported in a previous blog article about the [plans regarding OpenID Connect federation that came up from
tje SCS hackathon in Cologne](https://scs.community/2023/01/05/sig-iam-openstack-cli-with-federation/), the IAM part of
the SCS project decided to work on adding support for the [OAuth 2.0 Device Authorization
Grant](https://www.rfc-editor.org/rfc/rfc8628) to OpenStack Keystone.

Now we can report on progress on that topic: In March our proposal for a new auth plugin `v3oidcdeviceauthz` got
[accepted by the upstream OpenStack team](https://review.opendev.org/c/openstack/keystoneauth/+/869876) and
based on feedback we [finished an additional iteration of improvement in May](https://review.opendev.org/c/openstack/keystoneauth/+/876893).

During the [SCS Hackathon in Nuremberg](https://scs.community/2023/03/31/hackathon-nuernberg/) we worked on security
of the authorization flow between Keystone (or rather `mod_auth_openidc`) and Keycloak as IdP and decided that we
would like to use the "Authorization Code Flow with PKCE](https://www.rfc-editor.org/rfc/rfc7636) rather than the deprecated Implicit Grant flow, which
was used by default in the upstream kolla-ansible templates. But after [putting that in place in the testbed
repo](https://github.com/osism/testbed/commits/main/environments/kolla/files/overlays/keystone/wsgi-keystone.conf)
we found that this caused a regression when using the "OAuth 2.0 Device Authorization Grant" flow in openstack CLI.

After some research on the net it became apparent that the PKCE extension to the regular Authorization Code Grant flow
is generally compatible with the Device Autheorization Grant, yet very few vendors have implemented the combination.
While we could have worked around the issue by using different OIDC client configurations for openstack CLI and
Keystone, we decided to give it try and add the PKCE functionality to the `v3oidcdeviceauthz` auth plugin in Keystone.
Delayed somewhat by reviewer vacations [the patch got accepted mid-August](https://review.opendev.org/c/openstack/keystoneauth/+/883852).

This feels like some path nicely finished and also helped us to improve the working relationship with the upstream
OpenStack Keystone team. While we still work on some challanges with regards to mapping customer realms to the OpenStack
domain concept, we started [documenting our current concept of identity federation in SCS](https://docs-staging.scs.community/docs/iam/identity-federation-in-scs). This path is part of a larger journey and shows how we work starting on PoCs in the OSISM testbed
and then continue to work on upstreaming upcoming improvements towards OpenStack. This time it was code, but we also
proposed improvements to upstream documentationm where we feel like we wasted time by barking up the wrong tree.
The SCS project is a great opportinity to openly exchange experience with OpenStack and other components and
to extract best practice recommendations for the users of SCS. When it comes down to access control, it's vitally
important not to blindly follow upstream howtos, but to test what implications the proposed configuration has
and if it is still best practice today before implementing it as part of the project.

One example of this kind is the [case of Horizon logout](https://github.com/SovereignCloudStack/issues/issues/347):
During an SCS presentation we discovered that hitting logout
in OpenStack Horizon fooled you to believe that you where actually logged out. But with federated login
we found that you would be logged in again immediately without entering your password as the Keycloak session
did not get terminated and so the OpenID Connect token was stil valid. After some expermentation and research
we found that this problem was well know to OpenStack developers to such an extent that there was a blog article
explaining how to address that. In the weekly SIG IAM meeting we discussed this and a colleague from Wavestack
explained that they found an even better solution.
This has been [merged into the testbed](https://github.com/osism/testbed/pull/1717) some weeks ago
and we will continue with making that fix part of the bigger move to ship our configuration for identity federation
as part of the OSISM Cookiecutter repository to make it easily available to productive deployments of SCS.

Enjoy,
Arvid Requate (Member SCS "Operations and IAM" Team)
