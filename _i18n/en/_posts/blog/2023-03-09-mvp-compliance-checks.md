---
layout: post
title: "Automated Compliance Checks for SCS-Compatible Clouds"
image: "blog/checklist.png"
author:
  - "Ralf Heiringhoff"
  - "Eduard Itrich"
avatar:
  - "frosty-geek.webp"
  - "eitrich.jpg"
about:
  - "frosty-geek"
  - "eitrich"
---

We are excited to announce that we have implemented automated compliance checks for SCS compatible clouds. These checks are currently done via [GitHub Actions](https://github.com/SovereignCloudStack/standards/tree/main/.github/workflows), and soon we [plan](https://github.com/SovereignCloudStack/issues/issues/279) to move to the upcoming Zuul infrastructure.

Our compliance checks are organized as certification levels according to the [scs-0003-v1-sovereign-cloud-standards-yaml.md](https://github.com/SovereignCloudStack/standards/blob/main/Standards/scs-0003-v1-sovereign-cloud-standards-yaml.md), and we currently maintain one certification level called "scs-compatible". This certification level is described in the [Tests/scs-compatible.yaml](https://github.com/SovereignCloudStack/standards/blob/main/Tests/scs-compatible.yaml) file.

<figure class="figure mx-auto d-block" style="width:75%">
  {% asset 'blog/2023-03-09-scs-compatible-clouds.png' vips:format='.webp' style="width:100%; max-height: 450px; object-fit: contain;" %}
</figure>

The compliance checks are currently in the MVP phase and are being run nightly against several SCS-compatible clouds, including gx-scs, pluscloud open, and Wavestack. The results of these checks are displayed on our [GitHub repository](https://github.com/SovereignCloudStack/standards) in the form of badges, which indicate the compliance status of each cloud.

We hope that our automated compliance checks will encourage more cloud providers to adopt the SCS standards and make it easier for users to choose a cloud provider that is compatible with SCS. We also welcome feedback from the community on how we can improve our compliance checks and make them more useful for everyone.

A brief guide on how to use our test suite can be found in the [`README.md`](https://github.com/SovereignCloudStack/standards/tree/main/Tests#testsuite-for-scs-standards) within the [`Tests`](https://github.com/SovereignCloudStack/standards/tree/main/Tests) directory of the [standards repository](https://github.com/SovereignCloudStack/standards). The test suite expects `$OS_CLOUD` to be defined similar to the cloud name as in your local OpenStack configuration within `~/.config/openstack`.

```bash
git clone git@github.com:SovereignCloudStack/standards.git .
cd standards/Tests
docker run -it --env OS_CLOUD="mycloud" -v ~/.config/openstack:/root/.config/openstack:ro ghcr.io/sovereigncloudstack/scs-compliance-check:main scs-compatible.yaml iaas
```

The Docker image is built on every push to `main` from the corresponding [`Dockerfile`](https://github.com/SovereignCloudStack/standards/blob/main/Tests/Dockerfile) and automatically published to the [GitHub Container Registry](https://github.com/SovereignCloudStack/standards/pkgs/container/scs-compliance-check).

Stay tuned for more updates on our compliance checks as we continue to improve and expand our automated testing infrastructure!
