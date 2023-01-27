---
layout: post
title: "Brag with digital Swag and our new Community Member Profiles"
author:
  - "Eduard Itrich"
avatar:
  - "eitrich.jpg"
about:
  - "eitrich"
image: "blog/badges.jpg"
---

Community,

With huge excitement I would like to announce a new feature on our website that allows you to proudly show off all of your precious contributions to SCS. Your commitment is the foundation of our project's success and we definitely want to honor this!

## Introducing Community Member Profiles

Contributing to an Open Source project such as Sovereign Cloud Stack is not only essential for the project itself, but also a great way to publicly demonstrate your experience and knowledge. Be not humble and share with the rest of the world what you've learned, accomplished or contributed.

For instance, [Arvid](https://scs.community/members/arequate) from [Univention](https://univention.com) published an excellent article on [OpenStack API access with federation to external customer Identity Providers in Sovereign Cloud Stack](https://scs.community/2023/01/05/sig-iam-openstack-cli-with-federation/), which has been featured on all social media channels by [OpenStack](https://www.openstack.org/). Isn't it fantastic if this valuable work also creates visibility for the contributor as well as the company?

<figure class="figure mx-auto d-block" style="width:70%">
  <a href="{% asset "blog/community-profiles.png" @path %}">
    {% asset 'blog/community-profiles.png' class="figure-img w-100" %}
  </a>
</figure>

Creating your individual profile is easy and straightforward. All you have to do is to open a pull request in our [website repository](https://github.com/SovereignCloudStack/website).

<ol>
<li>Create a YAML file under <code>_members</code> with your individual handle following this template.
<div markdown=1>
```yaml
---
author_slug: jdoe
title: Jane Doe
layout: community
lastname: Doe
firstname: Jane
role: Community Hero
company: ACME Corporation
companylink: https://acme.org
holopin_username: jdoe
twitter: https://twitter.com/jdoe
linkedin: https://www.linkedin.com/in/jane-doe
github: https://github.com/jdoe
matrix: https://matrix.to/#/@jdoe:matrix.org
mastodon: https://hachyderm.io/@JDoe#
mail: jdoe@acme.org
website: https://jdoe.net
avatar: jdoe.jpg
bio: |
    Jane Doe is a highly skilled Cloud Architect and Open Source Ambassador at ACME Corporation. With over 10 years of experience in the tech industry, Jane has a proven track record of success in designing, implementing and managing cloud-based solutions. As a Cloud Architect at ACME, Jane is responsible for leading the company's cloud strategy and ensuring that all of their systems are scalable, secure, and cost-effective. She works closely with the development and operations teams to design and implement cloud-native solutions that meet the needs of the business. In addition to her role as a Cloud Architect, Jane is also an Open Source Ambassador at ACME. In this role, she works to promote the use of open source technologies within the company and to encourage contributions to open source projects. She is a strong advocate for open source and is committed to helping the community to grow and thrive.
---
```
</div>
</li>
<li>Upload a square avatar to <code>_assets/images</code>.</li>
<li>Add the following key (corresponding to the <code>author_slug</code> in your profile) to the front matter of all your old and upcoming blog posts.
<div markdown=1>
```yaml
about:
  - "jdoe"
```
</div>
</li>
<li>Open a pull request and wait for an approving review.</li>
<li>Share your brand new profile with your friends and network! 🎉</li>
</ol>

## Gotta Collect 'Em All!

Maybe you noticed the key `holopin_username` in the example above. Curious to learn more?

> [Holopin](https://www.holopin.io/) is a platform that allows you to earn verifiable digital badges for skills, achievements, and all the amazing things you do. Build collections and create your own badge board. Show off via LinkedIn, Twitter, GitHub and GitLab.
> And guess what? They're not NFTs.

Concurrent with our new Community Member Profiles, we are introducing a second way to recognize and reward your contributions: **collectable badges and achievements!**

<figure class="figure mx-auto d-block" style="width:70%">
  <a href="{% asset "blog/holopin-itrich.jpg" @path %}">
    {% asset 'blog/holopin-itrich.jpg' class="figure-img w-100" %}
  </a>
</figure>

We joined the Holopin Open Source partnership program and and as you read this we are in the middle of issuing our first digital stickers to all participants of [last year's Community Hackathon](https://scs.community/2022/11/25/hackathon-wrapup/). So sign up for <https://holopin.io> and start collecting our Sovereign Cloud Stack swag. What are you waiting for? The next badge is already lined up! 🔥