---
layout: post
title: "Demystifying Gaia-X Credentials"
author:
  - "Anja Strunk"
  - "Markus Hentsch"
avatar:
  - "avatar-candh.jpg"
---

## Generating compliant Verifiable Credentials using the GXDCH

<!-- TODO: figure showing the trust anchors on high level like https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/trust_anchors/ -->

We recommend reading the Gaia-X's own blog post on ["Gaia-X and Verifiable Credentials / Presentations"](https://gaia-x.eu/news-press/gaia-x-and-verifiable-credentials-presentations/) to get familiar with the idea and concepts behind **Verifiable Credentials** and **Verifiable Presentations**.

### Desired Goal

A provider wants to publish Gaia-X Credentials containing proven claims about their identity and offerings conforming to the Gaia-X Framework.
To achieve this, the provider assembles a Verifiable Presentation that contains several Verifiable Credentials which in total will both represent and prove the provider's identity and offerings.
The Verifiable Credentials, representing individual claims, are individually issued and signed either by the provider itself or an authorized third-party (such as the GXDCH), depending on their subjects.
Finally, the Gaia-X Compliance Service of the GXDCH will verify the Verifiable Presentation's contents (including the individual Verifiable Credentials and their proofs) and issue a Verifiable Credential attesting the compliance of the Verifiable Presentation as a whole:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-verifiable-presentation.png" @path %}">
    {% asset 'blog/gx-credentials/gx-verifiable-presentation.png' class="figure-img w-100" %}
  </a>
</figure>

### Required Identity Assets for Credential Creation

In order to successfully create Verifiable Credentials for the Gaia-X Compliance, the following assets are necessary on the provider side:

1. A DNS record and server for hosting the Gaia-X related identity assets.
2. A public/private key pair compatible with JSON Web Signatures (JWS) and a corresponding X.509 certificate chain containing the public key.
    - the X.509 certificate chain needs to be hosted publicly
3. A Decentralized Identifier (DID) for the DNS record.
    - the DID is a JSON file that needs to be hosted publicly

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-credentials-creation.png" @path %}">
    {% asset 'blog/gx-credentials/gx-credentials-creation.png' class="figure-img w-100" %}
  </a>
</figure>

The relations between those parts are as follows:

- the private key of the public/private key pair will be used by the provider to locally sign Verifiable Credentials
- the public key of the public/private key pair will be used by other parties to verify the signature of provider-signed Verifiable Credentials
- the public key is hosted by the provider as part of the DID JSON and certificate chain files
- the DID JSON contains both the public key for signature validation as well as a URL reference to the full X.509 certificate chain for its public key
- the path to the DID is encoded in the "proof" section of the Verifiable Credential

Using the DID and the certificate chain including the public key hosted by the provider, a consumer is able to verify the signature of a Verifiable Credential of the provider by resolving the DID reference and retrieving the certificate:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-credentials-verification.png" @path %}">
    {% asset 'blog/gx-credentials/gx-credentials-verification.png' class="figure-img w-100" %}
  </a>
</figure>

