---
layout: post
title: "Sovereign Cloud Stack Community Hackathon Nuremberg 2023"
image: hackathon-nuremberg-2023/hackathon-03-23_osism_IMG_0724.jpg
author:
  - "Ramona Beermann"
  - "Eduard Itrich"
avatar:
  - "RB.png"
  - "eitrich.jpg"
watchlist:
  - name: "Ceph in a box"
    url: "https://input.scs.community/p/scs-community-hackathon-2023-ceph-in-a-box#/"
  - name: "Workload identities"
    url: "https://input.scs.community/p/8xXw9cm-G#/"
  - name: "(Interactive) Overview for SCS Standards / Architecture"
    url: "https://input.scs.community/p/McKZb7j1R#/"
---

Four weeks ago our [second Community Hackathon]({% post_url blog/2023-01-27-hackathon-2023 %}) took place in Nuremberg. During this great event we gathered with familiar faces from our community as well as with new friends to work together on many interesting topics. All in all it was a very productive event with good discussions and lot of fun.

Special thanks go to the organizing companies of the event [Wavecon GmbH](https://www.wavecon.de/) and [OSISM GmbH](https://osism.tech). The data center tour at [noris network AG](https://www.noris.de/) was amazing. It was exciting to see one of the most modern data centers in Europe from the inside.

A big thanks goes to our community too. Without you the event wouldn't be so awesome. Thanks a lot to all.

But let us tell you a little more...

## Topics, people, talks and fantasic IT Infrastructure that makes every nerd's heart beat faster

The morning began with an empowering breakfast and many great conversations, which immediately relaxed the atmosphere at [noris network AG](https://www.noris.de/). After this we started to the data center tour. Two awesome employees from [noris network AG](https://www.noris.de/) guided us through the data center and answered all of our questions. In addition, they always had funny anecdotes ready, with which they brightened the mood even more. With these great impressions, we then went with a lot of energy to our topics that we had planned for the day.

As always, we publish all exciting topics on GitHub and on our website for further reading.

## This topics took place at the hackathon

<div class="row">
	<div class="col-lg-12">
		<div class="list-group mb-4">
      {% for session in page.sessions %}
      <div class="list-group-item list-group-item-action align-items-start">
        <div class="d-flex w-100 justify-content-between">
  					<a href="{{session.url}}" target="_blank" class="mb-1 text-decoration-none text-body stretched-link">{{session.name}}</a>
        </div>   
      </div>
      {% endfor %}
    </div>
    </div>
</div>

## Gallery

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/hackathon-nuremberg-2023/" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='SCS Community Hackathon 2023 Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>
