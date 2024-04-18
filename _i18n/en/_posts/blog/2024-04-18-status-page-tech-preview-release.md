---
layout: post
title: "SCS Status Page - Technical Preview Released"
category: "tech"
author:
  - "Sebastian Kaupe"
avatar:
  - "avatar-gonicus.jpg"
---

Now matter how thorough your preparation and processes, services experiencing limited capabilities and straight-out outages *will* be part your business of being a cloud provider.

To define and manage these incidents, the SCS project so far provided an [OpenAPI definition](https://github.com/SovereignCloudStack/status-page-openapi) as well as an [implementation](https://github.com/SovereignCloudStack/status-page-api) for a status API server, acting as a repository to collect any incidents that impact the components of your SCS setup. And while its REST interface is certainly comprehensive, fiddling around with HTTP calls and JSON results is not exactly a process one can consider *"customer-friendly"*.

## The SCS Status Page is now available as a Technical Preview

For the last few months, we've therefore been working on our first release of our Status Page, the web frontend to our status API server. The status page takes the API server's REST interface and provides a web view that your customers and employees can just look at in their browser—no curl calls or similar necessary.

<figure class="figure mx-auto d-block" style="width:100%; max-width: 986px;">
    {% asset 'blog/status-page-tech-preview-release/default-view.png' class="figure-img w-100 mx-auto" %}
</figure>
<p class="fw-semibold text-center">SCS Status Page default view</p>

If you've ever seen a status page before, this page design will surely be immediately familiar to you. We have, however, implemented for our technical preview a few things not commonly seen in the status pages we've encountered in our research.

The first is dedicated support for a colorblind mode. Up to roughly 9% of all humans have some form of color blindness and we wanted to make sure that our status page is properly visible to everyone with sufficient sight. Our implementation therefore ships with a default set of colors optimized to be seen by people with range of color vision deficiencies. These colors are, of course, customizable by your organization (and might by customizable by the user in some future release, but that is of yet uncertain), but should provide a decent experience to everyone.

<figure class="figure mx-auto d-block" style="width:100%; max-width: 986px;">
    {% asset 'blog/status-page-tech-preview-release/default-view-cb.png' class="figure-img w-100 mx-auto" %}
</figure>
<p class="fw-semibold text-center">SCS Status Page default view with colors optimized for the color blind</p>

The second feature is a different view mode. While the default bar view is fine for most people (and familiar to anyone who's ever had to deal with one of the many other status pages), there are people for whom the fine motor control to click on one of the little boxes representing a day in the bar view is simply not achievable. For these people (and everyone who simply likes tables), we have added a table view, listing the status and active incidents for every single day in one simple table per component.

<figure class="figure mx-auto d-block" style="width:100%; max-width: 986px;">
    {% asset 'blog/status-page-tech-preview-release/table-view.png' class="figure-img w-100 mx-auto" %}
</figure>
<p class="fw-semibold text-center">SCS Status Page table view with non-incident days filtered out</p>

And because the tables for your SCS system would hopefully mostly feature days without ongoing incidents, making your tables long and boring, we've added an option to remove all such days, giving you a much shorter, easily digestable table view of how your SCS environment has been doing.

Now, this is a *technical preview*, so not all work we want to be included in our first full release is currently done. Theming is currently somewhat limited, the About text and imprint can only be changed directly in the sources and the implementation in the background has one or two slightly wonky spots. However, we think our implementation is far along enough to be handed over to you, to experiment with it and hopefully provide us with some feedback on how we are doing. Check [further down below](#get-involved) to see how to get involved!

## The Future of the Status Page

For the moment (and our first complete release), the status page is a tool to purely view the status of your SCS environment. We have, however, a whole mountain of plans and ideas to implement in the future, chief amongst them the ability to create and update incidents and impacts for authenticated users, turning the status page into *the* tool to interact with the status API server. Additionally, we plan to extend the API specification, API server and frontend to schedule and display pre-planned maintenance sessions, allowing you to inform your users of expected outages well beforehand.

Alongside actual incident management, we want to add a notification service to server and frontend, allowing you to subscribe to push messages or e-mail notifications; or consume any updates to your SCS status at your own pace using RSS.

And many, many ideas more, such as additional facilities for disabled users (e. g. a high-contrast mode or colorblind modes specific to different types of color blindness), user-specified time ranges, customizable filter options or additional REST API endpoints. If incident management is part of your duties, make sure to have an eye on further announcements and developments on our status API and page.

## Get Involved!

You can find the Git repository of the status page [on GitHub](https://github.com/SovereignCloudStack/status-page-web). The README file includes instructions on how to construct a container image from the sources and how to configure the status page according to your needs/status API server setup. You have no status API server yet? Not a problem—the status page repo comes with some example data included and you can set a flag to make the status page use that, allowing you to try out the page on its own.

We'd love it if you had a look and informed us of any issues you encountered with the page! Whether these are with the setup, the page itself or any requirements you have that you do not see fulfilled either right now or within the scope of our planned future enhancements—tell us about it by [opening an issue on our repository](https://github.com/SovereignCloudStack/status-page-web/issues/new). And there is also a [Matrix room](https://matrix.to/#/#scs-status-page-app:matrix.org) for the status page project.

And if it would please you, you can of course get involved yourself! The status page is build using Angular 2 and TypeScript and comes with a Devcontainer setup for Visual Studio Code included, which should give you everything needed for a quick and easy setup of your development environment.