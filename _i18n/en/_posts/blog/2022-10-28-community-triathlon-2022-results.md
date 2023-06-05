---
layout: post
title: "Results of our SCS Community Triathlon – Let's hear it for our participants! 🎉"
author:
  - "Eduard Itrich"
  - "Bianca Hollery"
avatar:
  - "eitrich.jpg"
  - "employees/Hollery.jpg"
image: "triathlon2022/banner.jpg"
about:
  - "eitrich"
---

Community and friends,

thank you for your active participation in our [SCS Community Triathlon 2022]({% post_url blog/2022-08-18-community-triathlon-2022 %}),
we are still overwhelmed by your enthusiasm and the great feedback. You are awesome!

**So, let's hear it our for our winners and participants!** 🥁  

🥇 Give a big applause to the first winner - **[SEP Tri Team](https://www.sep.de/)**

<figure class="figure mx-auto d-block" style="width:50%">
    {% asset 'triathlon2022/winner.jpeg' class="figure-img w-100" %}
</figure>

🥈 Hip hip hooray for the second winner - **[Team Univention](https://www.univention.com/)**  
🥉 Congratulations to the third winner - **[Team SVA Öffis](https://sva.de/de)**  

We would also like to thank the following teams for participating in our community triathlon – you made this a great event:

- [B1 Systems](https://www.b1-systems.de/)
- [Hochschule Hof and friends](https://www.hof-university.de/)
- [plusserver](https://www.plusserver.com/)
- [OSISM](https://osism.tech/)
- [Konnektiv](https://konnektiv.de/)
- [OSB Alliance](https://osb-alliance.de/)
- WanderWomen (the only team completing the 30 km Hiking discipline)

As for the individual ranking, we congratulate

🏃🏻‍ David Kammerer from [B1 Systems](https://www.b1-systems.de/), who completed the 10 kilometer run in incredible **00:41:52 minutes**  
🚴 Manuel König from [SEP Tri Team](https://www.sep.de/) for for completing the 40km cycling in **01:06:28 hours**  
🏊 Markus Lindenblatt from [plusserver](https://www.plusserver.com/) for his record-breaking completion of the 1.5km swim in **00:22:15 minutes**  

## Gallery

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
  {% for image in assets %}
    {% if image[0] contains "images/triathlon2022/gallery" %}
      <div>
        <a href="{% asset '{{image[0]}}' @path %}">
          {% asset '{{image[0]}}' class='card-img-top rounded' alt='Open Infra Summit 2022 Gallery' vips:resize='500x500' vips:crop='high' vips:format='.webp' %}
        </a>
      </div>
    {% endif %}
  {% endfor %}
</div>

## Thank you!

We would like to thank [B1 Systems GmbH](https://b1-systems.de/)
and [Univention GmbH](https://www.univention.de/) for making this event possible!

<div class="row align-items-center justify-content-center">
	<div class="col-5 col-md-4 col-lg-3 p-3 d-flex justify-content-center">
  	<a href="https://b1-systems.de" title="B1 Systems GmbH" target="_blank">
  		{% asset 'logo-b1-systems.svg' alt='B1 Systems GmbH' class='mx-auto d-block img-fluid' vips:format='.webp' vips:resize='200x100' %}
  	</a>
	</div>
  <div class="col-5 col-md-4 col-lg-3 p-5 d-flex justify-content-center">
  	<a href="https://univention.de/" title="Univention GmbH" target="_blank">
  		{% asset 'logo-univention.png' alt='Aitus UG' class='mx-auto d-block img-fluid' vips:format='.webp' vips:resize='300x150' %}
  	</a>
	</div>
</div>

Hope to see you again next year!
