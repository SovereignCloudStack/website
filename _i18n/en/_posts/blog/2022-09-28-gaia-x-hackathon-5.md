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
  <a href="{% asset "blog/waltid-idp.png" @path %}">
    {% asset 'blog/waltid-idp.png' vips:format=".webp" class="figure-img w-100" %}
  </a>
  <figcaption class="figure-caption text-end">Identity federation via an external identity and access manager. All rights reserved by walt.id GmbH</figcaption>
</figure>

We issued a Gaia-X compliant Verifiable Credential (VC) of Type Legal Person for *Jane Doe* through the Gaia-X Compliance service.

```json
{
  "@context" : [ "https://www.w3.org/2018/credentials/v1" ],
  "credentialSubject" : {
    "gx-participant:blockchainAccountId" : "0x4C84a36fCDb7Bc750294A7f3B5ad5CA8F74C4A52",
    "gx-participant:headquarterAddress" : {
      "gx-participant:addressCode" : "DE-HH",
      "gx-participant:addressCountryCode" : "DE",
      "gx-participant:postal-code" : "22303",
      "gx-participant:street-address" : "Geibelstraße 46b"
    },
    "gx-participant:legalAddress" : {
      "gx-participant:addressCode" : "DE-HH",
      "gx-participant:addressCountryCode" : "DE",
      "gx-participant:postal-code" : "22303",
      "gx-participant:street-address" : "Geibelstraße 46b"
    },
    "gx-participant:legalName" : "deltaDAO AG",
    "gx-participant:registrationNumber" : {
      "gx-participant:registrationNumberNumber" : "391200FJBNU0YW987L26",
      "gx-participant:registrationNumberType" : "leiCode"
    },
    "gx-participant:termsAndConditions" : "0x4C84a36fCDb7Bc750294A7f3B5ad5CA8F74C4A52",
    "id" : "did:web:dids.walt-test.cloud"
  },
  "id" : "https://delta-dao.com/.well-known/participant.json",
  "issuanceDate" : "2022-09-15T20:05:20.997Z",
  "issuer" : "did:web:dids.walt-test.cloud",
  "type" : [ "VerifiableCredential", "LegalPerson" ],
  "proof" : {
    "type" : "JsonWebSignature2020",
    "created" : "2022-09-27T08:01:31Z",
    "proofPurpose" : "assertionMethod",
    "verificationMethod" : "did:web:dids.walt-test.cloud",
    "jws" : "eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJQUzI1NiJ9..MIRIuzRQcTJMtx-3UalA9bWnBml6oyzV2e_TYJbBs_BvFjwfhw_R9sUspdsjP3s94dp99OwI20DmYHqYW2QhLXrTqTUBJom8-hFa0-P8eiBZAZF27eGZgHpLq_UhpGXw_VzLxlwg0CE9FvBcf5fxRpTDzXTsOGFni1-Zg9G1DYYVg3UKt5yYsVH8-sGa97aY9y-UU4MkmxqNmlu96p9vl57aAyXNhWYQ_OtOMkPVqJds2-hUk0UhKt5r7QmPwoSAXFEB8GMUXc6G9bkcRhm0whwSwYqYFuSlfu2P9ln6-ZtPuu9juexfgeU6gx9p-uDYeiDzbfUslI4ExTY4wWJI1A"
  }
}
```

This VC will be used later to authenticate against our SCS testbed that we've prepared
the week before.

## Day 2
