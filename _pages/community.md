---
title: nav.title.community
layout: map
permalink: /community/
---
<style>
    .marker-pin {
      width: 40px;
      height: 40px;
      border-radius: 50% 50% 50% 0;
      position: absolute;
      transform: rotate(-45deg);
      left: 50%;
      top: 50%;
      margin: -20px 0 0 -28px;
    }

    .marker-pin::after {
        content: '';
        width: 34px;
        height: 34px;
        margin: 3px 0 0 3px;
        background: #fff;
        position: absolute;
        border-radius: 50%;
     }

    .marker-pin-icon {
       position: absolute;
       width: 28px;
       margin: 20px 0 0 0px;
    }
</style>

<div id="communitymap" style="width: 100%; height: 90vh;"></div>

<script>

    var communitymap = L.map('communitymap').setView([52.82291,  6.46217], 5);

    var Stamen_TonerLite = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}{r}.{ext}', {
        attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        subdomains: 'abcd',
        minZoom: 0,
        maxZoom: 20,
        ext: 'png'
    });

    Stamen_TonerLite.addTo(communitymap);

    {%- for supporter in site.data.supporter -%}
        {% if supporter.location.latitude and supporter.location.longitude %}
            icon = L.divIcon({
                className: 'custom-div-icon',
                html: "<div style='background-color:#50c3a5;' class='marker-pin'></div><img class='marker-pin-icon' src='{{ supporter.image | prepend: '/assets/images/' | prepend: site.baseurl_root }}' alt='{{ supporter.name }}'>",
                iconSize: [40, 56],
                iconAnchor: [20, 56]
            });
            var marker = L.marker([{{supporter.location.latitude}}, {{supporter.location.longitude}}], { icon: icon }).addTo(communitymap);
        {% endif %}
    {% endfor %}

</script>
