---
layout: post
title: "Demystifying Gaia-X Credentials"
author:
  - "Anja Strunk"
  - "Markus Hentsch"
avatar:
  - "avatar-candh.jpg"
---

This blog post will introduce the requirements and detailed technical process of creating and obtaining Verifiable Credentials (VC for short) for Gaia-X Self-Descriptions and using the Gaia-X Digital Clearing House (GXDCH) to assert compliance.

We recommend reading the Gaia-X's own blog post on [Gaia-X and Verifiable Credentials / Presentations](https://gaia-x.eu/news-press/gaia-x-and-verifiable-credentials-presentations/) to get familiar with the idea and concepts behind **Verifiable Credentials** and **Verifiable Presentations**.

The process described in this blog post is for the most part an example realization of [how to become a Gaia-X conformant user](https://docs.gaia-x.eu/policy-rules-committee/policy-rules-conformity-document/23.10/Process/) as documented by Gaia-X.

This blog post will refer to the latest stable Gaia-X release at the time of writing (which is 22.10 - codenamed "Tagus") and the corresponding [Gaia-X Trust Framework 22.10 release](https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/).
Details of the process described here might change in future Gaia-X releases. Please consult the corresponding documentation.

## Terminology

It is important to clarify some terms and concepts used throughout this blog post before moving on.

#### Gaia-X Credentials / Verifiable Credentials

Gaia-X regulates descriptions of Cloud Service Providers (CSPs) and their services as **Gaia-X Credentials**.
The term **Gaia-X Credential** refers to a **Verifiable Credential** in the context of Gaia-X.
It is based on [W3C Verifiable Credentials Data Model v1.1](https://www.w3.org/TR/vc-data-model/) but follows some more specialized restrictions specific to Gaia-X.
Those are described in the [Credential format documentation](https://docs.gaia-x.eu/technical-committee/identity-credential-access-management/22.10/credential_format/).
Notable key aspects are:

- The serialization format is [JSON-LD](https://json-ld.org/).
- The verification method type is [JSON Web Key](https://datatracker.ietf.org/doc/html/rfc7517) entailing [JSON Web Signature](https://datatracker.ietf.org/doc/html/rfc7515) as proof value.
- Claims [MUST use](https://docs.gaia-x.eu/technical-committee/identity-credential-access-management/22.10/credential_format/#namespace-bindings-and-contexts) the [Gaia-X Onotology](https://gitlab.com/gaia-x/technical-committee/service-characteristics-working-group/service-characteristics) in their context.
- Any `id` fields of Verifiable Credentials (including their `credentialSubject.id`) [MUST be unique](https://docs.gaia-x.eu/technical-committee/identity-credential-access-management/22.10/credential_format/#identifiers).

In this blog post, the term Verifiable Credential is used interchangeably with Gaia-X Credential.

#### Gaia-X Self-Descriptions / Verifiable Presentations

**Gaia-X Self-Descriptions** on the other hand [are described as follows](https://docs.gaia-x.eu/technical-committee/identity-credential-access-management/22.10/credential_format/#self-description-format-and-structure):

> Gaia-X Self-Description documents are Verifiable Presentations following the [W3C Verifiable Credentials Data Model](https://www.w3.org/TR/vc-data-model/).

A **Verifiable Presentation** contains or references one or more Verifiable Credentials.
A Verifiable Presentation representing a CSP and their offerings as a form of self-description is usually submitted to the Compliance Service of the Gaia-X Digital Clearing House (GXDCH), resulting in a Gaia-X Credential that attests the compliance.

In this blog post, the term Verifiable Presentation is used interchangeably with Gaia-X Self-Description.

## Desired Goal

This blog post will be based on the following use case:

A provider wants to publish Gaia-X Credentials containing proven claims about their identity and offerings conforming to the Gaia-X Framework and achieve Gaia-X compliance.
To achieve this, the provider assembles a Verifiable Presentation that contains several Verifiable Credentials which in total will both represent and prove the provider's identity and offerings as a form of self-description.
The Verifiable Credentials, representing individual claims, are individually issued and signed either by the provider itself or an authorized third-party (such as the GXDCH), depending on their subjects.
Finally, the Gaia-X Compliance Service of the GXDCH will verify the Verifiable Presentation's contents (including the individual Verifiable Credentials and their proofs) and issue a Verifiable Credential attesting the compliance of the Verifiable Presentation as a whole.

This process is summarized in the following figure:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-verifiable-presentation.png" @path %}">
    {% asset 'blog/gx-credentials/gx-verifiable-presentation.png' class="figure-img w-100" %}
  </a>
</figure>

Most Verifiable Credentials included in the Verifiable Presentation are self-signed by the provider.
One exception to this is the Verifiable Credential for the Legal Registration Number (LRN) of the provider which instead is signed by the GXDCH involving a dedicated Gaia-X Notarization Service API for verifying the LRN and attesting its validity.

The specific set of Verifiable Credentials a provider includes in their Verifiable Presentation may vary depending on what kind of proven claims the provider wants to present.
For the purpose of this blog post we will focus on a very common and basic use case of Verifiable Presentations containing the following Verifiable Credentials:

1. The **Legal Registration Number** (LRN) belonging to the provider.
2. The **Participant** credential representing the provider as a legal person identified by the LRN.
3. The signed Gaia-X **Terms & Conditions** which the provider pledges to adhere to.

## Required Identity Assets for Credential Creation

In order to successfully create Verifiable Credentials for the Gaia-X Compliance as illustrated above, the following assets are necessary on the provider side:

1. A DNS record and web server for hosting the Gaia-X related identity assets.
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

## Creating a compliant Verifiable Presentation step-by-step

The following sections of this blog post will guide through the individual steps of creating the necessary identity assets, basic Verifiable Credentials and finally the Verifiable Presentation.

The steps will require an up and running web server with a registered DNS record where files can be served from.
This server and its DNS record will be referred to as `mydomain.com` for the explanations below.

### Step 1: Preparing the public/private key pair

For the purpose of this blog post we will be using Let's Encrypt for generating the public/private key pair and X.509 certificate chain.
This makes the process very quick and easy and we can focus on the more intericate parts of the Gaia-X-specific workflow.
Note that for the Gaia-X production release, a X.509 certificate chain originating from one of the [Gaia-X Trust Anchors](https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/trust_anchors/#list-of-defined-trust-anchors) will be required, which excludes Let's Encrypt as it does not offer EV SSL certificates.
For testing this process, we can use the "v1-staging" Gaia-X API intended for development and testing purposes, which is a bit more lenient in this regard and will accept Let's Encrypt certificates.

Please refer to the official [Certbot ACME client documentation](https://certbot.eff.org/instructions) on how to get started with Let's Encrypt on a web server.
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
(this example assumes `/srv/` is the path your web server serves files from)

The `crt.sh` URL to the ISRG Root X1 certificate in this example was retrieved from [Mozilla's index of included CA certificates](https://wiki.mozilla.org/CA/Included_Certificates).

Host the `x509CertificateChain.pem` on the web server accordingly.
It will be required for the next step.

If the web server is not configured for HTTPS yet, these key files may be used for its TLS configuration as well.

### Step 2: Creating the Decentralized Identifier (DID) document

A central element of the whole process of verifying Verifiable Credentials is the Decentralized Identifier (DID for short) of the corresponding signee. Gaia-X uses [W3C's DID standard](https://www.w3.org/TR/did-core/) for those.
A DID document is linked to the private key used to sign Verifiable Credentials and contains verification assets (e.g. public key) for verification as illustrated in the introductory section. 

The DID document must be publicly accessible and is usually referenced in Verifiable Credentials using the [DID-specific URI scheme](https://www.w3.org/TR/did-core/#a-simple-example), for example: `did:web:my-domain.com`.
The [`did:web` method](https://w3c-ccg.github.io/did-method-web/) specified in the example will resolve to `https://my-domain.com/.well-known/did.json`.

Some notes about the `did:web` method used here:

- HTTPS (TLS) is mandatory for the `did:web` method and is automatically chosen.
- When no path segments are specified after the domain name (using colon delimiters), this method defaults to `.well-known/` on the web server.
- The resulting URL will be used to look up `did.json` on the web server, this filename is hardcoded.

To generate the DID document, the [SCS DID creator](https://github.com/SovereignCloudStack/scs-did-creator/) can be utilized.
Specify the URL to `x509CertificateChain.pem` certificate chain file as input for the verification methods.

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
        ...
      },
      ...
    }
  ],
  ...
}
```
(contents truncated for readability)

This file is to be placed as `/.well-known/did.json` on the web server, e.g. `mydomain.com/.well-known/did.json`.
As a result it will be accessible using the DID reference `did:web:mydomain.com` which we will be using when creating Verifiable Credentials in the following steps.

**Important:** Each `verificationMethod` entry in the DID document receives a unique `id` field. When creating Verifiable Credentials referencing the DID document, their `proof.verificationMethod` value must exactly match one of the `id`s within `verificationMethod` of the DID document! This includes the `#`-prefixed appendix (`did:web:mydomain.com#JWK2020-RSA` in this example).

### Step 3: Verifiable Credential for Legal Registration Number (LRN)

To be acknowledged as a proper participant in the Gaia-X Trust Framework we need to legally identify ourselves as a [legal person](https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/participant/#legal-person) that represents our entity (e.g. company).
For this purpose we need a Verifiable Credential for our Legal Registration Number (LRN) as a requirement for our Participant Verifiable Credential later on.

As mentioned in the introductory sections, the LRN Verifiable Credential takes a special position in this context as it is one of the few Verifiable Credentials that the provider will not sign itself.
Instead, the trust anchor lies at the Gaia-X Digital Clearing House which verifies the LRN and attests its validity.
The Clearing House has a dedicated API for this: the Notarization API.
You can use the [Gaia-X Wizard](https://wizard.lab.gaia-x.eu/legalRegistrationNumber) for creating the Verifiable Credential or use the Notarization API directly.

There is a notable quirk about the process here that needs some explanation before we go on.
When requesting a LRN Verifiable Credential a **Verifiable Credential identifier** must be provided.
This corresponds to "Verifiable Credential ID" in the Gaia-X Wizard or the "vcid" path parameter of the API.
In addition to that a **credential subject identifier** will need to be specified as well.
This corresponds to "Credential subject ID" in the Gaia-X Wizard or the "id" request body field when using the API.
Below is a visualization of this structure:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-lrn-credential-structure.png" @path %}">
    {% asset 'blog/gx-credentials/gx-lrn-credential-structure.png' class="figure-img w-100" %}
  </a>
</figure>

Instead of using a identifier that is only valid locally within a Verifiable Presentation (more on that later) we can opt for both identifiers to contain the URL to hosted instance of our LRN Verifiable Credential.
For the purpose of demonstration, we will do that next but keep in mind that this is optional for Verifiable Credentials as the [Gaia-X documentation on identifiers](https://docs.gaia-x.eu/technical-committee/identity-credential-access-management/22.10/credential_format/#identifiers) states:

> It is up to the issuer to decide if the @id is a resolvable URI or not.

Strictly speaking, we are not the issuer this time around (the GXDCH is) but since the Notarization API allows us to specify those identifiers, we will keep that responsibility nonetheless and have the choice here.

We are just about to receive the Verifiable Credential and as such we don't have the URL to it yet that we want to use in the identifiers, so the process can seem a bit unintuitive.
The solution is to prematurely specify the URL where we *intend* to put the Verifiable Credential, in our example this will be `https://mydomain.com/.well-known/lrn.json`.
The link is not actually validated by the Notarization API as it only issues the Verifiable Credential itself.
To adhere to the requirement of keeping identifiers unique, we can use a trick to attach arbitrary anchors to the URL in order to keep both identifiers different while still resolving to the same URL:

- Verifiable Credential identifier: `https://mydomain.com/.well-known/lrn.json`
- Credential subject identifier: `https://mydomain.com/.well-known/lrn.json#subject`

A corresponding request body to the Tagus release version of the Notarization API would look as follows.

Request URL:

```
POST https://registrationnumber.notary.lab.gaia-x.eu/v1/registrationNumberVC?vcid=https://mydomain.com/.well-known/lrn.json#subject
```

Request Body:

```json
{
  "@context": [
    "https://registry.lab.gaia-x.eu/v1-staging/api/trusted-shape-registry/v1/shapes/jsonld/participant"
  ],
  "type": "gx:legalRegistrationNumber",
  "id": "https://mydomain.com/.well-known/lrn.json",
  "gx:vatID": "DE123456789"
}
```

Note: It is not mandatory to use the `/.well-known/` directory here.
In contrast to the DID document, web server, path and filename can be arbitrary here as long as we host the resulting Verifiable Credential at this address later on.
This is true for all the Verifiable Credentials that we will create in the following sections.

The Notarization API supports different types of Legal Registration Numbers, including VAT ID which our example uses.

In the response to this request we receive our first Verifiable Credential from the Notarization API in JSON format.
Below is an example of how such a Verifiable Credential will look like based on the request data above.

```json
{
    "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://w3id.org/security/suites/jws-2020/v1"
    ],
    "type": [
        "VerifiableCredential"
    ],
    "id": "https://mydomain.com/.well-known/lrn.json",
    "issuer": "did:web:registration.lab.gaia-x.eu:v1",
    "issuanceDate": "2024-06-25T14:38:38.898Z",
    "credentialSubject": {
        "@context": "https://registry.lab.gaia-x.eu/development/api/trusted-shape-registry/v1/shapes/jsonld/trustframework#",
        "type": "gx:legalRegistrationNumber",
        "id": "https://mydomain.com/.well-known/lrn.json#subject",
        "gx:vatID": "DE123456789",
        "gx:vatID-countryCode": "DE"
    },
    "evidence": [
        {
            "gx:evidenceURL": "http://ec.europa.eu/taxation_customs/vies/services/checkVatService",
            "gx:executionDate": "2024-06-25T14:38:38.898Z",
            "gx:evidenceOf": "gx:vatID"
        }
    ],
    "proof": {
        "type": "JsonWebSignature2020",
        "created": "2024-06-25T14:38:38.916Z",
        "proofPurpose": "assertionMethod",
        "verificationMethod": "did:web:registration.lab.gaia-x.eu:v1#X509-JWK2020",
        "jws": "<signature>"
    }
}
```
(the JWS signature field has been replaced by the placeholder `<signature>` for readability)

We will put this JSON file on our web server at the path we specified during the request, i.e. `mydomain.com/.well-known/lrn.json`.

The Verifiable Credential that we received contains a DID reference to the DID document of the Gaia-X Notarization Service which in turn will reference a X.509 certificate chain of the Notarization Service that can be used to validate the signature of the Verifiable Credential.
Refer to the appendix section at the bottom of this blog post for a Python code snippet for validating the signature.

In contrast to the figures above, the issuer is the GXDCH and the provider itself is just the holder of this Verifiable Credential:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-lrn-credential-creation.png" @path %}">
    {% asset 'blog/gx-credentials/gx-lrn-credential-creation.png' class="figure-img w-100" %}
  </a>
</figure>

Based on this LRN credential we can proceed with our first self-signed Verifiable Credential next: the Participant.

### Step 4: Verifiable Credential for Participant

The [Participant in the Gaia-X Trust Framework](https://docs.gaia-x.eu/policy-rules-committee/trust-framework/22.10/participant/) is described as:

> [...] a Legal Person or Natural Person, which is identified, onboarded and has a Gaia-X Self-Description.

In case of a Legal Person (our case), the Legal Registration Number is required which we just acquired the Verifiable Credential for in the previous step.

Since the Participant Verifiable Credential will be the first credential that we sign ourselves in this process, we will need three additional key assets that we prepared in earlier steps:

1. The `privkey.pem`, our private key for signing the credential.
2. The `did:web:` reference pointing to our hosted DID document, which in turn points to our hosted certificate chain.
3. The credential subject identifier of our LRN Verifiable Credential to reference to.

The LRN credential's `credentialSubject.id` value will need to be specified within `credentialSubject.gx:legalRegistrationNumber.id` of the Participant Verifiable Credential:

<figure class="figure mx-auto d-block" style="width:50%">
  <a href="{% asset "blog/gx-credentials/gx-participant-lrn-reference" @path %}">
    {% asset 'blog/gx-credentials/gx-participant-lrn-reference' class="figure-img w-100" %}
  </a>
</figure>

This time we are going to create and sign the Verifiable Credential ourselves.
Here is how it could look like:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://w3id.org/security/suites/jws-2020/v1",
    "https://registry.lab.gaia-x.eu/v1-staging/api/trusted-shape-registry/v1/shapes/jsonld/trustframework#"
  ],
  "type": [
    "VerifiableCredential"
  ],
  "id": "https://mydomain.com/.well-known/participant.json",
  "issuer": "did:web:mydomain.com",
  "issuanceDate": "2024-01-01T00:00:00.000000",
  "credentialSubject": {
    "id": "https://mydomain.com/.well-known/participant.json#subject",
    "type": "gx:LegalParticipant",
    "gx:legalName": "My Company Ltd.",
    "gx:legalRegistrationNumber": {
      "id": "https://mydomain.com/.well-known/lrn.json#subject"
    },
    "gx:headquarterAddress": {
      "gx:countrySubdivisionCode": "DE-BE"
    },
    "gx:legalAddress": {
      "gx:countrySubdivisionCode": "DE-BE"
    }
  }
}
```

Note that similar to the LRN Verifiable Credential we are once again specifying a URL that does not exist yet for this credential's identifiers: `https://mydomain.com/.well-known/participant.json`.
We will place this very credential there once we signed it.
Furthermore, we are using the same anchor method (`#subject`) to keep identifiers unique as already explained for the LRN credential earlier.

To sign the Verifiable Credential we need to add a JSON Web Signature (JWS) to it.
Please refer to the appendix at the bottom of this blog post for an example Python implementation utilizing the `jwcrypto` library.
As a result, the structure shown above will be extended by a "proof" section containing the signature like this:

```json
  ...
  "proof": {
    "type": "JsonWebSignature2020",
    "proofPurpose": "assertionMethod",
    "verificationMethod": "did:web:mydomain.com#JWK2020-RSA",
    "jws": "<signature>"
  }
}
```

To make the identifier references valid, we will place the signed JSON at `mydomain.com/.well-known/participant.json` on our web server.
Other Gaia-X Participants may now retrieve this Verifiable Credential along with our DID document and its referenced X.509 certificate chain in order to validate the signature of our credential as illustrated in the figures of the introductory sections.

### Step 5: Verifiable Credential for Terms & Conditions

The second Verifiable Credential that we will sign ourselves will be the Gaia-X Terms & Conditions which we pledge to adhere to as a participant in the Gaia-X Trust Framework.

The mandatory Terms & Conditions text can be found at <https://registry.lab.gaia-x.eu/v1-staging/api/trusted-shape-registry/v1/shapes/jsonld/trustframework> within the `gx:GaiaXTermsAndConditionsShape`.
A resulting credential JSON using example values may look like this:

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://w3id.org/security/suites/jws-2020/v1",
    "https://registry.lab.gaia-x.eu/v1-staging/api/trusted-shape-registry/v1/shapes/jsonld/trustframework#"
  ],
  "type": "VerifiableCredential",
  "issuanceDate": "2024-01-01T00:00:00.000000",
  "credentialSubject": {
    "type": "gx:GaiaXTermsAndConditions",
    "gx:termsAndConditions": "The PARTICIPANT signing the Self-Description agrees as follows:\n- to update its descriptions about any changes, be it technical, organizational, or legal - especially but not limited to contractual in regards to the indicated attributes present in the descriptions.\n\nThe keypair used to sign Verifiable Credentials will be revoked where Gaia-X Association becomes aware of any inaccurate statements in regards to the claims which result in a non-compliance with the Trust Framework and policy rules defined in the Policy Rules and Labelling Document (PRLD).",
    "id": "https://mydomain.com/.well-known/gx-terms-and-cs.json#subject"
  },
  "issuer": "did:web:mydomain.com",
  "id": "https://mydomain.com/.well-known/gx-terms-and-cs.json"
}
```

The structure and content of the credential is slightly different but the process is the same as for the Participant Verifiable Credential.
In short:

1. Sign the JSON using the `privkey.pem`.
2. Extend the JSON by a "proof" section containing the JSON Web Signature (JWS).
3. Publish the resulting Verifiable Credential as JSON at `mydomain.com/.well-known/gx-terms-and-cs.json`.

Once again, other Gaia-X Participants may now retrieve this signed credential and validate its signature using our DID reference and the resulting public key.

### Step 6: Building the Verifiable Presentation for the Compliance API

Here is a recap of the assets we created so far:

1. Our public/private key pair, the X.509 certificate and DID document.
2. A Verifiable Credential attesting our Legal Registration Number (LRN), signed by the Gaia-X Notarization Service.
3. A self-signed Verifiable Credential describing our identity as Participant, referencing our LRN credential.
4. A self-signed Verifiable Credential for the Gaia-X Terms & Conditions we pledge to adhere to.

Using this minimal set of credentials we can now build a Verifiable Presentation for ourselves and submit it to the [Gaia-X Compliance API](https://compliance.lab.gaia-x.eu/v1-staging/docs).
The Verifiable Presentation will act as our [Gaia-X Self-Description](https://docs.gaia-x.eu/technical-committee/architecture-document/22.10/self-description/).

The process is pretty straightforward and only requires us to assemble all desired Verifiable Credentials in a Verifiable Presentation structure:

```json
{
  "@context": "https://www.w3.org/2018/credentials/v1",
  "type": "VerifiablePresentation",
  "verifiableCredential": [
    {
      // signed LRN credential
    },
    {
      // signed Participant credential
    },
    {
      // signed Terms & Conditions credential
    }
  ]
}
```

The JSON objects within the `verifiableCredential` list are the full signed JSON structures (including the "proof" section) as individually created in the previous steps.
They are omitted and replaced by placeholders here for readability.

We simply send this request body to `https://compliance.lab.gaia-x.eu/v1-staging/api/credential-offers` and as a response we receive yet another Verifiable Credential, assumed that the Gaia-X Compliance Service can successfully validate the signature of each individual credential contained in the Verifiable Presentation.

This time, the received credential does not contain the whole input structure again, which would include the full JSON representation of all Verifiable Credentials included in the Verifiable Presentation.
Instead, credentials are only referenced by their subject ID and a hash of their content as received by the Gaia-X Compliance Service:

```json
{
    ...
    "credentialSubject": [
        {
            "type": "gx:compliance",
            "id": "https://mydomain.com/.well-known/lrn.json",
            "gx:integrity": "sha256-<hash>",
            ...
            "gx:type": "gx:legalRegistrationNumber"
        },
        {
            "type": "gx:compliance",
            "id": "https://mydomain.com/.well-known/gx-terms-and-cs.json",
            "gx:integrity": "sha256-<hash>",
            ...
            "gx:type": "gx:GaiaXTermsAndConditions"
        },
        {
            "type": "gx:compliance",
            "id": "https://mydomain.com/.well-known/participant.json",
            "gx:integrity": "sha256-<hash>",
            ...
            "gx:type": "gx:LegalParticipant"
        }
    ],
    "proof": {
        ...
    }
}
```
(output truncated for readability)

This final Verifiable Credential is the Gaia-X Compliance VC and attests the compliance of our Verifiable Presentation and its included credentials.
We can now share the Verifiable Presentation as our Self-Description along with this Gaia-X Compliance VC as proof.

## Summary

In this blog post we introduced the basic concepts of Verifiable Credentials and Verifiable Presentations used by participants of the Gaia-X Trust Framework.
We presented the requirements and basic steps for getting started with creating Verifiable Credentials as a provider.
Based on this foundation, a Verifiable Presentation was constructed in a step-by-step fashion consisting of an example set of credentials for submission to the Gaia-X Compliance Service.
At each step we made sure to point out the crucial details of properly linking and providing the required identity assets in compliance to the Gaia-X framework.
At the final step we submitted the Verifiable Presentation to the Gaia-X Compliance Service and received our Gaia-X Compliance VC.

By adding further credentials about service offerings to the Verifiable Presentation this process can easily be extended to create complete Gaia-X Self-Descriptions as a provider.
For SCS cloud infrastructures, this will be covered by the [SCS gx-credential-generator](https://github.com/SovereignCloudStack/gx-credential-generator) tool which is able to automatically generate the full set of Gaia-X Credentials including all applicable service offerings based on a SCS infrastructure.
In conjunction with the [SCS DID creator](https://github.com/SovereignCloudStack/scs-did-creator/) this will make most manual steps in this process unnecessary for SCS-compliant infrastructures.

The created Self-Description can later be registered in the [Federated Catalogues of Gaia-X](https://docs.gaia-x.eu/technical-committee/architecture-document/22.10/federation_service/#federated-catalogue) to make them discoverable for consumers within the Gaia-X ecosystem.

# Appendix

## Python code for signing Verifiable Credentials

The following code snippet illustrates how to build a signed Verifiable Credential using the `jwcrypto` library and the assets introduced in this blog post.
The code is loosely based on [this example implementation from a Gaia-X workshop](https://gitlab.com/gaia-x/lab/workshops/gaia-x-101/-/blob/e0b01980eead64c0a20fec4643659b4c9d9f3331/utils.py) that was published and licensed under the [Eclipse Public License - v 2.0](https://gitlab.com/gaia-x/lab/workshops/gaia-x-101/-/blob/e0b01980eead64c0a20fec4643659b4c9d9f3331/LICENSE).

```python
import json
from hashlib import sha256
from jwcrypto import jws, jwk
from jwcrypto.common import json_encode
from pyld import jsonld


def compact_token(token):
    parts = token.split(".")
    return parts[0] + ".." + parts[2]


def sign_credential(credential):
    # The private key used for signing
    private_key = jwk.JWK.from_pem("privkey.pem")
    # DID reference to the did.json
    verification_method = "did:web:mydomain.com#JWK2020-RSA"
    # URDNA normalize
    normalized = jsonld.normalize(
        credential, {'algorithm': 'URDNA2015', 'format': 'application/n-quads'}
    )
    # sha256 the RDF
    normalized_hash = sha256(normalized.encode('utf-8'))
    # Sign using JWS
    jws_token = jws.JWS(normalized_hash.hexdigest())
    jws_token.add_signature(private_key, None,
                            json_encode(
                                {"alg": "PS256",
                                "b64": False,
                                "crit": ["b64"]}
                            ),
                            json_encode({"kid": private_key.thumbprint()}))
    signed = jws_token.serialize(compact=True)

    # Add the "proof" section to the credential
    credential['proof'] = {
        "type": "JsonWebSignature2020",
        "proofPurpose": "assertionMethod",
        "verificationMethod": verification_method,
        "jws": compact_token(signed)
    }

    return credential
```

## Python code for verifying signed Verifiable Credentials

The following code snippet illustrates how to validate the JSON Web Signature (JWS) of a given Verifiable Credential.
The code is loosely based on [this example implementation from a Gaia-X workshop](https://gitlab.com/gaia-x/lab/workshops/gaia-x-101/-/blob/e0b01980eead64c0a20fec4643659b4c9d9f3331/utils.py) that was published and licensed under the [Eclipse Public License - v 2.0](https://gitlab.com/gaia-x/lab/workshops/gaia-x-101/-/blob/e0b01980eead64c0a20fec4643659b4c9d9f3331/LICENSE).

```python
import requests
import json
from hashlib import sha256
from jwcrypto import jwk, jws
from pyld import jsonld


def verify_credential(credential_json_str, cert_url):
    """
    credential_json_str : the signed Verifiable Credential as JSON string.

    cert_url : the URL to the signature verification certificate usually
    encoded as the x5u attribute of the issuer's did.json document.
    """

    verifiable_credential = json.loads(credential_json_str)

    # Retrieve the registry certificate which serves as the verification
    # public key (JWK) for the JWS later
    reg_cert_response = requests.get(cert_url)
    if reg_cert_response.status_code != 200:
        raise Exception(
            f"Unable to retrieve verification certificate "
            f"from: {cert_url}"
        )
    verification_cert_pem = reg_cert_response.text.encode('UTF-8')
    verification_key = jwk.JWK.from_pem(verification_cert_pem)

    # The proof object is part of the credential response, however
    # it resembles JWS data applicable to the response without the
    # proof object. Hence, we need to strip the proof object from
    # the response.
    proof = verifiable_credential.pop("proof")

    # The remaining structure is the actual credential data that
    # JWS was created for. The signature was applied to its
    # normalized and hashed form, which we need to recreate here
    # in order to verify the signature.
    # See: https://w3c.github.io/vc-data-integrity/#how-it-works
    normalized_credential = jsonld.normalize(
        verifiable_credential,
        {'algorithm': 'URDNA2015', 'format': 'application/n-quads'}
    )
    hashed_credential = sha256(normalized_credential.encode('utf-8'))

    # Instantiate a JWS object based on the jws attribute of the
    # proof object, which contains a base64 representation of the JWS.
    received_jws_token = jws.JWS()
    received_jws_token.deserialize(proof["jws"])

    # Finally, use the verification key (Gaia X registry public cert)
    # and the hashed credential (which is the JWS' detached payload)
    # in conjunction with the JWS token to verify the credential.
    # This method will throw an exception if verification fails.
    received_jws_token.verify(
        verification_key,
        detached_payload=hashed_credential.hexdigest()
    )
```