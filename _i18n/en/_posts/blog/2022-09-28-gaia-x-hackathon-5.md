---
layout: post
title:  "Sovereign Cloud Stack at Gaia-X Hackathon #5"
author:
  - "Eduard Itrich"
avatar:
  - "eitrich.jpg"
image: "blog/gx-hackathon-5.jpg"
---

As previously, our community engaged in the
[Gaia-x Hackathon #5](https://gitlab.com/gaia-x/gaia-x-community/gx-hackathon/gx-hackathon-5/-/wikis/home)
on September 26 – 27, 2022 with
[an own proposal](https://gitlab.com/gaia-x/gaia-x-community/gx-hackathon/gx-hackathon-5/-/wikis/Hackathon-5-Proposals#07-cloud-federation-via-oidc). The goal of our track was to realize user federation at the infrastructure level
with Keycloak via OpenID Connect.

<figure class="figure mx-auto d-block" style="width:50%">
    {% asset 'blog/gx-hackathon-5.jpg' class="figure-img w-100" %}
</figure>

Following the organizers' recommendation, we joined forces with the team from [walt.id](https://walt.id),
which in the end proved to be a great opportunity and resulted in an interesting use case.
After aligning our both proposals, we concluded to work together on realizing a
SSI-based authentication with Gaia-X compliant Legal Person credentials for the IaaS layer of our reference implementation.

## Day 1

The first day of our joint hacking session was organized by the walt.id team which gave us
a very good insight into SSI and their open-source technology, i.e. the [walt.id SSI Kit](https://github.com/walt-id/waltid-ssikit),
the [walt.id Web Wallet](https://github.com/walt-id/waltid-web-wallet) and the
[walt.id IdP Kit](https://github.com/walt-id/waltid-idpkit). The following figure gives
a good overview of how these components act together.

<figure class="figure mx-auto d-block w-75">
  <a href="{% asset "gx-hackathon-5/waltid-idp.png" @path %}">
    {% asset 'gx-hackathon-5/waltid-idp.png' vips:format=".webp" class="figure-img w-100" %}
  </a>
  <figcaption class="figure-caption text-end">Identity federation via an external identity and access manager. All rights reserved by walt.id GmbH</figcaption>
</figure>

We created a self-signed Legal Person Credential via the walt.id SSI Kit and subsequently issued a Participant Credential through
the Gaia-X Compliance API.

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://w3id.org/security/suites/ed25519-2020/v1",
    "https://w3id.org/security/suites/jws-2020/v1"
  ],
  "credentialSchema": {
    "id": "https://raw.githubusercontent.com/walt-id/waltid-ssikit-vclib/master/src/test/resources/schemas/ParticipantCredential.json",
    "type": "JsonSchemaValidator2018"
  },
  "credentialStatus": {
    "id": "https://gaiax.europa.eu/status/participant-credential#392ac7f6-399a-437b-a268-4691ead8f176",
    "type": "CredentialStatusList2020"
  },
  "credentialSubject": {
    "ethereumAddress": "0x4C84a36fCDb7Bc750294A7f3B5ad5CA8F74C4A52",
    "hasCountry": "GER",
    "hasJurisdiction": "GER",
    "hasLegallyBindingName": "deltaDAO AG",
    "hasRegistrationNumber": "DEK1101R.HRB170364",
    "hash": "9ecf754ffdad0c6de238f60728a90511780b2f7dbe2f0ea015115515f3f389cd",
    "id": "did:web:wallet.walt-test.cloud:api:did-registry:2ede544a02964e2e83a0cbe0a0683bf6",
    "leiCode": "391200FJBNU0YW987L26",
    "parentOrganisation": "",
    "subOrganisation": ""
  },
  "id": "urn:uuid:8d959928-d727-46b7-98af-b89c09b4cfb1",
  "issued": "2022-09-26T10:15:50Z",
  "issuer": "did:web:wallet.walt-test.cloud:api:did-registry:2ede544a02964e2e83a0cbe0a0683bf6",
  "proof": {
    "created": "2022-09-26T10:15:50Z",
    "creator": "did:web:wallet.walt-test.cloud:api:did-registry:2ede544a02964e2e83a0cbe0a0683bf6",
    "jws": "eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFZERTQSJ9..hMZNpUfax_Wu4PavK3kfYUI00JlqhOdZoWxuzO3dyWABeEFqdvLTkhJEq9nDskiYnYTIa6aWJID9q6yOGeVhDQ",
    "proofPurpose": "assertionMethod",
    "type": "JsonWebSignature2020",
    "verificationMethod": "did:web:wallet.walt-test.cloud:api:did-registry:2ede544a02964e2e83a0cbe0a0683bf6"
  },
  "validFrom": "2022-09-26T10:15:50Z",
  "issuanceDate": "2022-09-26T10:15:50Z",
  "type": [
    "VerifiableCredential",
    "ParticipantCredential"
  ]
}
```

This VC will be used later to authenticate against our SCS testbed that we've prepared
the week before.

## Day 2

The second day started with a very good discussion about user federation between
multiple SCS-compliant cloud offerings. We identified three possible scenarios
for *Jane Doe*:

* CSP Alpha (with OpenStack + Keycloak Alpha)
* CSP Beta (with OpenStack + Keycloak Beta)
* Company ACME Org. with user Jane Doe
  * without any IAM (but with a SSI kept in a wallet)
  * on own Keycloak of ACME Org.
  * on third-party Keycloak SaaS provider

This resulted in the following whiteboard that we sketched during brainstorming.

<figure class="figure mx-auto d-block w-75">
  <a href="{% asset "gx-hackathon-5/gx-hackathon-5-sketch.png" @path %}">
    {% asset 'gx-hackathon-5/gx-hackathon-5-sketch.png' vips:format=".webp" class="figure-img w-100" %}
  </a>
  <figcaption class="figure-caption text-end">Brainstorming on the multiple scenarios of user federation with Keycloak</figcaption>
</figure>

The rest of the day we spent on integrating the walt.id IdP into our Keycloak. Unfortunately
we ran into an [issue in Keycloak 19.0.1](https://github.com/keycloak/keycloak-ui/issues/3355)
which prevented us from setting the OIDC Identity Provider Client Authentication to *Basic Authentication*
via the UI.

We decided to change the value `clientAuthMethod` via `kcadm.sh` and used the following trick
```bash
/opt/jboss/keycloak/bin/kcadm.sh get realms/osism > osism.json
sed -e 's/clientAuth_basic/client_secret_basic/' osism.json > osism2.json
/opt/jboss/keycloak/bin/kcadm.sh create partialImport -r osism -s ifResourceExists=OVERWRITE -o -f osism2.json
```

Finally, we were able to use the Gaia-X compliant Participant Credential we've created earlier
to authenticate against our Keycloak instance. 🎉

<div class="row row-cols-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/gx-hackathon-5/auth-flow" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='CloudMon Mini Hackathon Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>

## Open questions

We identified several challenges that are still open to discussion.

* Jane Doe needs so sign in to have an entity on Keycloak Alpha and Keycloak Beta. How will rights and privileges then be mapped by Keycloak Alpha and Beta without knowing anything about Jane Doe (besides her company)?
* CSP have to setup own Keycloaks that have to accept everything from the third party Keycloak provider. Will this find acceptance?
* We need to tackle how permission rights for Jane Doe are maintained – especially across multiple CSP.

## Thank you!

The two days of the Gaia-X Hackathon #5 were yet again very interesting and we had a lot of fun
spending time together and hacking together. We especially thank the Gaia-X OSS Community
for organizing this great opportunity and Phillip, Severin and Kai from walt.id for cooperating with us.

Many thanks also to our community members who participated in our session and contributed their knowledge.
You are awesome! 🚀

## Join us

Interested in continuing working on user federation? We still have some open challenges to tackle
and we invite you to join our open community. Check out [our public calendar](https://scs.community/contribute/)
and participate in our various team meetings.
