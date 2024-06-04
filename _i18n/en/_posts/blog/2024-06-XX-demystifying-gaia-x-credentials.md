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

<!-- TODO: ![figure showing the trust anchors]() -->

### Identity Assets for Credential Creation

In order to successfully create Verifiable Credentials for the Gaia-X Compliance, the following assets are necessary:

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