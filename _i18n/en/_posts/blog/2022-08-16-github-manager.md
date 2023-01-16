---
layout: post
title:  "Introducing github-manager for consistent repository and organization management"
category: tech
author:
  - "Tim Beermann"
  - "Eduard Itrich"
avatar:
  - "tbeermann.jpeg"
  - "eitrich.jpg"
image: "blog/github.jpg"
about:
  - "eitrich"
---

Thanks to the preliminary work from our friends at [OTC](https://github.com/opentelekomcloud)
and the extensive support by [Tim](https://github.com/tibeer) from [OSISM GmbH](https://github.com/osism),
we're introducing a new way to manage our repositories and our [Sovereign Cloud Stack organization](https://github.com/SovereignCloudStack)
on GitHub.

## Why?

As our project progresses and the community grows, so does the number of repositories
and members of our organization on GitHub. Keeping a consistent set of protection and
access rules can be hard, especially if we want to foster a self-organizing community.

Using a gitops-like approach helps us to address this challenge in several ways:

* Branch protection rules are enforced in a consistent way among all our repositories
and can be managed at one central place.
* Write and access rules can be configured in a transparent and consistent way for
all our repositories.
* Users can join our GitHub organization by simply opening a pull request and thus
we enable a self-service on-boarding experience.
* Define a consistent set of labels for all our repositories. This helps us to make
extensive use of the GitHub project board feature.
* We have a transparent audit log of what has been changed within our organization.

## How?

To achieve this, we're making use of the awesome [`gitcontrol Ansible collection`](https://github.com/opentelekomcloud/ansible-collection-gitcontrol)
by the [OTC](https://github.com/opentelekomcloud) team.

Both, configuration and workflows can be found at the [`github-manager`](https://github.com/SovereignCloudStack/github-manager) repository.
This will be the single source of truth to manage our repositories and GitHub organization.

<div class="alert alert-warning" role="alert" markdown="1">
  <b>For this to work properly, some rules must be followed:</b>
* After creating or renaming a repository, please define this new repository at [`github-manager/orgs/SovereignCloudStack/repositories/`](https://github.com/SovereignCloudStack/github-manager/tree/main/orgs/SovereignCloudStack/repositories)
* After deleting a repository, please delete the corresponding file at [`github-manager/orgs/SovereignCloudStack/repositories/`](https://github.com/SovereignCloudStack/github-manager/tree/main/orgs/SovereignCloudStack/repositories)
* Don't change the settings (e.g. access rules, description, features, etc.) of our repositories manually, but define them in the corresponding files
* Don't change protection rules manually, but configure them at [`github-manager/templates/`](https://github.com/SovereignCloudStack/github-manager/tree/main/templates)
* Don't invite new members manually to our organization, but add them to [`github-manager/blob/main/orgs/SovereignCloudStack/people/members.yml`](https://github.com/SovereignCloudStack/github-manager/blob/main/orgs/SovereignCloudStack/people/members.yml)
* Don't create new teams, but add them to [`github-manager/orgs/SovereignCloudStack/teams/members.yml`](https://github.com/SovereignCloudStack/github-manager/blob/main/orgs/SovereignCloudStack/teams/members.yml)
* Don't add milestones and labels manually, but add them to [`github-manager/config.yaml`](https://github.com/SovereignCloudStack/github-manager/blob/main/config.yaml)
</div>

## Some caveats and further hints

The `github-manager` workflow has some limitations that need to be considered.

To be able to manage the GitHub organization, the workflow needs a valid [PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) of a organization owner. This is currently only the case for Eduard. The SIG Community is working on extending the workflow to add multiple PAT.
Until then, only Eduard is currently able to trigger the workflow by merging into the `main` branch or dispatching it manually.

In the transition to the `github-manager` we also renamed all old `master` branches to `main`. To switch to the new default branch, please do the following in the corresponding repositories:

```bash
git branch -m master main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
```

## Next steps

This was only a first step. In the following, we will discuss how we want to grant
write and access rights within our community and which protection rules are reasonable
to enforce among our repositories.

If you have any questions or feedback, you can always contact [Eduard](https://scs.community/itrich)
or reach out to the [SIG Community](https://scs.community/contribute/) that meets biweekly
Wednesday at 11:05 CEST.
