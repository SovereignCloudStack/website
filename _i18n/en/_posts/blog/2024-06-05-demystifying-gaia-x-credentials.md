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

The process described in this blog post is for the most part an example realization of [how to become a Gaia-X conformant user](https://docs.gaia-x.eu/policy-rules-committee/policy-rules-conformity-document/23.10/Process/) as documented by Gaia-X.

This blog post will refer to the latest stable Gaia-X release which is codenamed "Tagus" (at the time of writing) and the corresponding [Gaia-X Trust Framework 22.10 release](https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/).
Details of the process described here might change in future Gaia-X releases. Please consult the corresponding documentation.

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

Most Verifiable Credentials included in the Verifiable Presentation are self-signed by the provider.
One exception to this is the Verifiable Credential for the Legal Registration Number (LRN) of the provider which instead is signed by the GXDCH involving a dedicated Gaia-X Notary Service API for verifying the LRN and attesting its validity.

The specific set of Verifiable Credentials a provider includes in their Verifiable Presentation may vary depending on what kind of proven claims the provider wants to present.
For the purpose of this blog post we will focus on a very common and basic use case of Verifiable Presentations containing the following Verifiable Credentials:

1. The **Legal Registration Number** (LRN) belonging to the provider.
2. The **Participant** credential representing the provider as a legal person identified by the LRN.
3. The signed Gaia-X **Terms & Conditions** which the provider pledges to adhere to.

### Required Identity Assets for Credential Creation

In order to successfully create Verifiable Credentials for the Gaia-X Compliance as illustrated above, the following assets are necessary on the provider side:

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
- the DID JSON contains both the public key for signature validation as well as a URL reference to the full X.509 certificate chain for the public key
- the path to the DID is encoded in the "proof" section of the Verifiable Credential

Using the DID and the certificate chain including the public key hosted by the provider, a consumer will be able to verify the signature of a Verifiable Credential issued by the provider by resolving the DID reference and retrieving the certificate:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-credentials-verification.png" @path %}">
    {% asset 'blog/gx-credentials/gx-credentials-verification.png' class="figure-img w-100" %}
  </a>
</figure>

### Step 1: Preparing the public/private key pair

For the purpose of this blog post we will be using Let's Encrypt for generating the public/private key pair and X.509 certificate chain.
This makes the process very quick and easy and we can focus on the more intericate parts of the Gaia-X-specific workflow.
Note that for the Gaia-X production release, a X.509 certificate chain originating from one of the [Gaia-X Trust Anchors](https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/trust_anchors/#list-of-defined-trust-anchors) will be required, which excludes Let's Encrypt as it does not offer EV SSL certificates.
For testing this process, we can use the "v1-staging" Gaia-X API intended for development and testing purposes, which is a bit more lenient in this regard and will accept Let's Encrypt certificates.

Please refer to the official [Certbot ACME client documentation](https://certbot.eff.org/instructions) on how to get started with Let's Encrypt on a webserver.
Using Certbot to perform the key generation and certificate issuance results in the following files:

- `privkey.pem`
  - the private key of your public/private key pair
- `cert.pem`
  - your resulting certificate (a leaf certificate), includes the public key of your key pair
- `chain.pem`
  - Let's Encrypt's intermediate certificate
- `fullchain.pem`
  - certificate chain, simply a combination of `cert.pem` and `chain.pem`

The `chain.pem` certificate is only an intermediate certificate.
It references [Let's Encrypt's root certificate](https://letsencrypt.org/certificates/#root-cas) (ISRG Root X1/X2) but the `fullchain.pem` does not include it.
Since the Gaia-X Compliance API will require the full certificate chain (including the root certificate) to be present for validation later on, the certificate chain needs to be adjusted.

This can be done by manually building the full certificate chain:

```sh
# start building the certificate chain from the leaf and intermediate certificates
cat cert.pem chain.pem | tee /srv/.well-known/x509CertificateChain.pem

# retrieve and append the ISRG Root X1 certificate
curl -s \
    https://crt.sh/?d=96BCEC06264976F37460779ACF28C5A7CFE8A3C0AAE11A8FFCEE05C0BDDF08C6 \
    | tee -a /srv/.well-known/x509CertificateChain.pem
```
(this example assumes `/srv/` is the path your webserver serves files from)

The `crt.sh` URL to the ISRG Root X1 certificate in this example was retrieved from [Mozilla's index of included CA certificates](https://wiki.mozilla.org/CA/Included_Certificates).

Host the `x509CertificateChain.pem` on the webserver accordingly.
It will be required for the next step.

If the webserver is not configured for HTTPS yet, these key files may be used for its TLS configuration as well.

### Step 2: Creating the Decentralized Identifier (DID)

A central element of the whole process of verifying Verifiable Credentials is the Decentralized Identifier (DID for short) of the corresponding signee. Gaia-X uses [W3C's DID standard](https://www.w3.org/TR/did-core/) for those.
A DID document is linked to the private key used to sign Verifiable Credentials and contains verification assets (e.g. public key) for verification as illustrated in the introductory section. 

The DID document must be publicly accessible and is usually referenced in Verifiable Credentials using the [DID-specific URI scheme](https://www.w3.org/TR/did-core/#a-simple-example), for example: `did:web:my-domain.com`.
The [did:web method](https://w3c-ccg.github.io/did-method-web/) specified in the example will resolve to `https://my-domain.com/.well-known/did.json`.

Some notes about the did:web method used here:

- HTTPS (TLS) is mandatory for the did:web method and is automatically chosen.
- When no path segments are specified after the domain name (using colon delimiters), this method defaults to `.well-known/` on the webserver.
- The resulting URL will be used to look up `did.json` on the webserver, this filename is hardcoded.

To generate the DID document, the SCS DID generator can be utilized.
Specify the `x509CertificateChain.pem` certificate chain file as input for the verification methods.
<!-- TODO: link to the SCS DID generator -->

Make sure to double check that you don't accidentally reference your private key in the DID document!
In the context of your key pair, only the public key and a reference to the X.509 certificate chain should be part of this document.

If done correctly, the DID document should contain our public key and the URL of the `x509CertificateChain.pem` file:

```json
{
  ...
  "id": "did:web:mydomain.com",
  "verificationMethod": [
    {
      "id": "did:web:mydomain.com#JWK2020-RSA",
      "type": "JsonWebKey2020",
      "publicKeyJwk": {
        "n": "<public key here>",
        "x5u": "https://mydomain.com/.well-known/x509CertificateChain.pem"
      },
      ...
    }
  ],
  ...
}
```
(contents truncated for readability)

This file is to be placed as `/.well-known/did.json` on the webserver, e.g. `mydomain.com/.well-known/did.json`.
As a result it will be accessible using the DID reference `did:web:mydomain.com` which we will be using when creating Verifiable Credentials in the following steps.
