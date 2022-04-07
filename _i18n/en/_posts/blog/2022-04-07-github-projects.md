---
layout: post
title:  "Moving to GitHub Projects"
category: tech
author:
  - "Eduard Itrich"
avatar:
  - "/assets/images/eitrich.jpg"
image: "/assets/images/blog/github.jpg"
---

Community,

we've had a great time planning [our third release](https://scs.community/release/2022/03/22/release2/)
with [Wekan](https://wekan.github.io/), but now it's time to say goodbye and break apart. 💔

It's not your fault, Wekan – but we need to lower the bar informing about or contributing to SCS. 
A repeated criticism during the past team's retrospectives was the fragmentation of
the tools we use within our community. You're all absolutely right and we urgently
to fix this.

For this reason, we decided to move to GitHub's new projects experience and bundle our developing
efforts on one single platform. This provides our contributors and guests with a
single point of entry and at the same time enhances the transparency and accessibility
of our project.

## GitHub Projects

The new projects experience is still considered as beta, but proves to be quite
stable in our tests. Check out the [documentation](https://docs.github.com/en/issues/trying-out-the-new-projects-experience)
for further information on how to use this new feature.

<figure class="figure mx-auto d-block" style="width:70%">
  <a href="{{ "/assets/images/blog/gh-projects-1.png" | prepend: site.baseurl_root }}">
    <img src="{{ "/assets/images/blog/gh-projects-1.png" | prepend: site.baseurl_root }}" class="figure-img w-100">
  </a>
</figure>

Our release planing board can be found on the [top organization level](https://github.com/SovereignCloudStack)
and reached via the ["Projects" tab](https://github.com/orgs/SovereignCloudStack/projects?type=beta).
The ["Sovereign Cloud Stack R3" project](https://github.com/orgs/SovereignCloudStack/projects/6)
is publicly available and can be modified by every [member of our Sovereign Cloud Stack organization](https://github.com/orgs/SovereignCloudStack/people).

## Raising `issues` from the dead

Technically, every item in a GitHub project is an issue in one of the organization's repositories.
Should an user story not be directly assignable to one of our code repositories, we decided to
use the [issues repository](https://github.com/SovereignCloudStack/issues) for this.

To keep track in our new board, we have created [different labels](https://github.com/SovereignCloudStack/issues/labels).
This allows us to use view filters and, in the future, to automate workflows.

Due to [Tim's efforts](https://github.com/SovereignCloudStack/github-permissions/pull/12) we
can easily manage these labels in a `git` repository and apply them to all of our repositories.
Thank you very much for this contribution!

In addition, we have created [several issue templates](https://github.com/SovereignCloudStack/issues/tree/main/.github/ISSUE_TEMPLATE)
to help you create new issues. The [template for new user stories](https://github.com/SovereignCloudStack/issues/blob/main/.github/ISSUE_TEMPLATE/standard-user-story.md)
has been extended by a first draft for a common Definition of Ready (DoR) and
Definition of Done (DoD). Feel free to open pull requests against this template if
you think that we've missed an important item in these lists.

<figure class="figure mx-auto d-block" style="width:70%">
  <a href="{{ "/assets/images/blog/gh-projects-2.png" | prepend: site.baseurl_root }}">
    <img src="{{ "/assets/images/blog/gh-projects-2.png" | prepend: site.baseurl_root }}" class="figure-img w-100">
  </a>
</figure>

## Tl;dr

Please consider the following steps while creating a new user story for R3:

* Open the issue in the `issues` repository if the user story should not be directly assignable to
  any other SCS repository.
* Choose the "Standard User Story" template.
* Add the label `IaaS`, `Container` or `Ops` according to responsible team.
* Add the issue to the "Sovereign Cloud Stack R3" project.
* Add the `v4.0.0` Milestone.

Have a look at our [first user story for R3](https://github.com/SovereignCloudStack/issues/issues/16)
and feel free to use it as a blueprint for all of your great ideas. We'll be using the
team meetings during the next weeks to have a look at the unfinished user stories
in our [Wekan](https://ms.scs.sovereignit.de/wekan) and move them *manually* to GitHub.
We have consciously decided against an automatic transfer, in order to use this opportunity
to check the old user stories again and to refine them if necessary. We are looking
forward to the upcoming sessions with you!