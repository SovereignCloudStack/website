---
layout: post
title:  "SCS at the OpenInfra Summit 2022 – Schedule and Community Gathering"
author:
  - "Eduard Itrich"
  - "Bianca Hollery"
avatar:
  - "eitrich.jpg"
  - "employees/Hollery.jpg"
---

We're just one week ahead of the [OpenInfra Summit 2022](https://openinfra.dev/summit/)
and we're thrilled to meet you all on-site again. This post is to inform you about
our activities at this truly important and exciting event for our community. Numerous
members will be present with various talks and sessions throughout all three days.
We have collected all contributions of our community below and we hope to see you
at one or the other presentation.

## Schedule

<div class="container my-4">
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
            <h3 class="title mb-2">{{talk.title}}<a data-tab-destination="day-{{i}}" href="#session-{{ forloop.index }}" class="link-unstyled"><i class="fa fa-link ms-2 text-muted" aria-hidden="true" style="font-size: .7em; color: "></i></a></h3>
            <div class="location mb-2 text-muted"><i class="fa fa-map-marker me-2" aria-hidden="true"></i>{{talk.location}}</div>
            <div class="desc pb-2">{{talk.description}}</div>
          </div><!--//content-->
        </div>
      {% endif %}
      {% endfor %}
    </div> 
  {% endfor %}
  </div>
  <div class="schedule-cta text-center mx-auto">
    <a href="https://openinfra.dev/summit-schedule" class="btn btn-primary btn-lg me-md-2 d-block d-md-inline-block mb-3 mb-md-0" target="_blank">See complete Schedule</a>
    <a href="https://www.eventbrite.com/e/openinfra-summit-berlin-2022-tickets-211374997307" class="btn btn-secondary btn-lg d-block d-md-inline-block" target="_blank">Buy Tickets</a>
  </div>
</div>

## Community Meetup

We're excited to invite you to our community gathering on **Wednesday, June 8** (formerly known as _„the secret party“_).

Let’s meet from 7 pm at the [c-base e.V.](https://c-base.org) (Rungestraße 20, 10179 Berlin), which is about 15 min by public transport from the Berlin Congress center (if you are probably attending the OpenInfra Summit).

<div class="row align-items-center justify-content-center">
{% for i in (1..3) %}
	<div class="col-4 d-flex justify-content-center">
  	{% asset 'oif_summit2022/c-base-{{i}}.jpg' alt='c-base' class='mx-auto d-block img-fluid' vips:format='.webp' %}
	</div>
{% endfor %}
</div>

<div class="schedule-cta text-center mx-auto my-4">
  <a href="https://graphhopper.com/maps/?point=bcc%20berlin%20congress%20center%2C%2010178%2C%20Berlin%2C%20Germany&point=c-base%2C%2010179%2C%20Berlin%2C%20Germany&locale=en-US&elevation=false&profile=foot&use_miles=false&layer=OpenStreetMap" class="btn btn-secondary btn-lg d-block d-md-inline-block" target="_blank">Navigate me to the party</a>
</div>

Join us for food and drinks[^1], for continuing the conversations started during the day or making plans for the next meeting. We thank our sponsors [OSISM GmbH](https://osism.tech) und [Aitus UG](https://aitus.eu/) for the food – they are both members of the [Open Source Business Alliance e.V.](https://osb-alliance.com) - as well as the c-base for the great opportunity to have our social event in their space station. 😉

<div class="row align-items-center justify-content-center">
	<div class="col-6 d-flex justify-content-center">
  	<a href="https://osism.tech" title="OSISM GmbH" target="_blank">
  		{% asset 'logo-osism.png' alt='OSISM GmbH' class='mx-auto d-block img-fluid' vips:format='.webp' vips:resize='300x150' %}
  	</a>
	</div>
  <div class="col-6 p-5 d-flex justify-content-center">
  	<a href="https://aitus.eu/" title="Aitus UG" target="_blank">
  		{% asset 'logo-aitus.png' alt='Aitus UG' class='mx-auto d-block img-fluid' vips:format='.webp' vips:resize='300x150' %}
  	</a>
	</div>
</div>

[^1]: Please note that we cannot cover the beverage.

## Contact us

If you need any further information, please contact [Eduard](https://scs.community/itrich) or [Bianca](https://scs.community/hollery) – they’ll be happy to help you. See you in Berlin!

<div class="row justify-content-center my-4">
  <div class="col-3 d-flex justify-content-center">
    <div class="card" style="width: 13rem;">
      {% asset 'employees/Itrich.jpg' class="card-img-top img-fluid" style="width: 100%; max-height: 35vh; object-fit: cover; object-position: top;" %}
      <div class="card-body">
        <p class="card-text"><i class="fa fa-phone me-3"></i><a class="link-unstyled stretched-link" href="tel:+49-30-206539-204">+49-30-206539-204</a></p>
      </div>
    </div>
  </div>
  <div class="col-3 d-flex justify-content-center">
    <div class="card" style="width: 13rem;">
      {% asset 'employees/Hollery.jpg' class="card-img-top img-fluid" style="width: 100%; max-height: 35vh; object-fit: cover; object-position: top;" %}
      <div class="card-body">
        <p class="card-text"><i class="fa fa-phone me-3"></i><a class="link-unstyled stretched-link" href="tel:+49-30-206539-204">+49-30-206539-206</a></p>
      </div>
    </div>
  </div>
</div>

<!-- JavaScript to create deep links within tab -->

<script type="text/javascript">
  $(function() {
      openTabHash();
      window.addEventListener("hashchange", openTabHash, false);
  });
  
  function openTabHash()
  {
      // Javascript to enable link to tab
      var url = document.location.toString();
      if (url.match('#day')) {
          $('.nav-item a[href="#'+url.split('#')[1]+'"]').tab('show') ;
      } else if (url.match('#session')) {
          var day = $('.item-talk .content a[href="#'+url.split('#')[1]+'"]').closest('.tab-pane').attr('id');
          $('.nav-item a[href="#'+day+'"]').tab('show');
          $('html, body').animate({
            scrollTop: $('a[href="#'+url.split('#')[1]+'"]').offset().top - 65
          }, 300);
      }
      
      $('.nav-item a').on('shown.bs.tab', function (e) {
        e.preventDefault();
        $('html, body').animate({
          scrollTop: $('a[href="#'+url.split('#')[1]+'"]').offset().top - 65
        }, 300);
      });
      
      $('.nav-item').click(function() {
          if (history.pushState) {
              history.pushState(null, null, "#" + $(' a', this).get(0).href.split('#')[1]); 
          } else {
              window.location.hash = "#" + $(' a', this).get(0).href.split('#')[1];
          }
      })
    }
</script>