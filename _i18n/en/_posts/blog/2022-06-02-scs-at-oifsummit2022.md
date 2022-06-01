---
layout: post
title:  "SCS at the OpenInfra Summit 2022 – Schedule and Community Gathering"
author:
  - "Eduard Itrich"
avatar:
  - "eitrich.jpg"
---

We're just one week ahead of the [OpenInfra Summit 2022](https://openinfra.dev/summit/)
and we're thrilled to meet you all on-site again. This post is to inform you about
our activities at this truly important and exciting event for our community. Numerous
members will be present with various talks and sessions throughout all three days.
We have collected all contributions of our community below and we hope to see you
at one or the other presentation.

<div class="container">
  <h2 class="mb-4">Schedule</h2>
  <!-- Nav tabs -->
  <ul class="schedule-nav nav nav-pills nav-fill" id="schedule-tab" role="tablist">
    <li class="nav-item me-2">
      <a class="nav-link active" id="tab-day-1" data-bs-toggle="tab" href="#day-1" role="tab" aria-controls="day-1" aria-selected="true">
        <span class="heading">Day 1</span>
        <span class="meta">(Tuesday, June 7)</span>
      </a>
    </li>
    <li class="nav-item me-2">
      <a class="nav-link" id="tab-day-2" data-bs-toggle="tab" href="#day-2" role="tab" aria-controls="day-2" aria-selected="false">
        <span class="heading">Day 2</span>
        <span class="meta">(Wednesday, June 8)</span>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-day-3" data-bs-toggle="tab" href="#day-3" role="tab" aria-controls="day-3" aria-selected="false">
        <span class="heading">Day 3</span>
        <span class="meta">(Thursday, June 9)</span>
      </a>
    </li>
  </ul>
  <!-- Tab panes -->
	<div class="schedule-tab-content tab-content mt-5">
  {% for i in (1..3) %}
		<div class="tab-pane fade {% if i == 1 %}show active{% endif %}" id="day-{{i}}" role="tabpanel" aria-labelledby="day-{{i}}">
      {% for talk in site.data.oif_summit2022 %}
      {% if i == talk.day %}
        <div class="item item-talk">
          <div class="meta">
            <h4 class="time">{{talk.start}} – {{talk.end}}</h4>
              <div class="profile mt-3">
                <div class="d-flex justify-content-center">{% assign post = talk %}{% include news/blog_avatars.html %}</div>
                <div class="name mt-2">{{talk.speaker | join: "<br/>"}}</div>
              </div><!--//profile-->
          </div><!--//meta-->
          <div class="content">
            <h3 class="title mb-2">{{talk.title}}<a href="#session-{{ forloop.index }}" class="link-unstyled"><i class="fa fa-link ms-2 text-muted" aria-hidden="true" style="font-size: .7em; color: "></i></a></h3>
            <div class="location mb-2 text-muted"><i class="fa fa-map-marker me-2" aria-hidden="true"></i>{{talk.location}}</div>
            <div class="desc pb-2">{{talk.description}}</div>
          </div><!--//content-->
        </div>
      {% endif %}
      {% endfor %}
    </div> 
  {% endfor %}
  </div>
</div>