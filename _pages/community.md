---
title: nav.title.community
layout: default
permalink: /community/
---
{% leaflet_map { "center" : [52.82291,  6.46217],
                 "zoom" : 6,
                 "divId": "communitymap",
                 "providerBasemap": "Stamen.TonerLite" } %}
    {%- for supporter in site.data.supporter -%}
        {% if supporter.location.latitude and supporter.location.longitude %}
            {% leaflet_marker { "latitude" : {{supporter.location.latitude}},
                                "longitude" : {{supporter.location.longitude}},
                                "popupContent" : "{{supporter.name}}",
                                "href" : "{{supporter.link}}"} %}
        {% endif %}
    {% endfor %}
{% endleaflet_map %}