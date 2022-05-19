---
title_slug: nav.jobs
layout: default
permalink: /jobs/
redirect_from:
   - /Jobs/
   - /Jobs/index.html.de
   - /Jobs/index.html.en
---
<div class="row">
  <div class="col-md-12">
    <h1>{% t page.title_slug %}</h1>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
      {% for job in site.jobs %}
        <div class="col">
          <div class="card h-100">
            <img src="{{ job.image | prepend: "/assets/images/" | prepend: site.baseurl_root }}" class="card-img-top img-fluid" style="width: 100%; max-height: 20vh; object-fit: cover; object-position: center;">
            <div class="card-body">
              <a href="
              {%- capture content_length -%}{{job.content | strip}}{%- endcapture -%}
              {%- if content_length == blank -%}
              mailto:jobs-scs@osb-alliance.com
              {%- else -%}
              {{ site.baseurl }}{{job.url}}
              {%- endif -%}
              " class="text-decoration-none text-body stretched-link"> <h5 class="card-title">{% t job.title_slug %}</h5></a>
              <p class="card-text">{% t job.short_description %}{{job.content | strip | size}}</p>
            </div>
            <div class="card-footer">
              <small class="text-muted">{{job.location}}</small>
            </div>
          </div>
        </div>
      {% endfor %}
    </div>
  </div>
</div>