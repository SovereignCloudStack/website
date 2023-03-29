---
layout: post
title: "Sovereign Cloud Stack Community Hackathon Nuremberg 2023"
image: #ToDo
author:
  - "Ramona Beermann"
avatar: #ToDo
about: #ToDo
---

Four weeks ago our fantastic hackathon took place in Nuremberg. During this great event we met many from our community and worked together on many interesting topics. All in all it was a very productive event with many good discussions.

Special thanks go to the organizing companies of the event Wavecon GmbH and OSISM GmbH. The data center tour at noris network AG was amazing. It was very exciting to see one of the most modern data centers in Europe from the inside.
A big thanks goes to our community too. Without you the event wouldn't be so awesome. Thanks a lot to all.

But let us tell you a little more...

## Topics, people, talks and fantasic IT Infrastructure that makes every nerd's heart beat faster

The morning began with an empowering brekfast and many great conversations, which immediately relaxed the atmosphere at noris network AG. After this we started to the data center tour. Two awesome employees from noris network AG showed us the data center and answered all of our questions. In addition, they always had funny anecdotes ready, with which they brightened the mood even more. With these great impressions, we then went with a lot of energy to our topics that we had planned for the day.

As allways, we publish all exciting topics on GitHub and on our website for further reading.

## This topics took place at the hackathon

<!--- TODO: Slides/Präsentationen ----->

## Gallery

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
  {% for image in assets %}
    {% if image[0] contains "images/hackathon2023/gallery" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='SCS Community Hackathon 2023 Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>
