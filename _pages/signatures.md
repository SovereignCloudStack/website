---
title: Mail Signatures
permalink: /signatures
---
<head>
<meta charset="UTF-8">
</head>
# E-Mail Signatures
{% for employee in site.data.employees %}
## {{employee.firstname}}:
### HTML:
<!-- Begin Signature {{employee.firstname}} -->
<a href="https://scs.community/{{employee.lastname}}">{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}</a>
\- <a href="mailto:{{employee.mail}}">&lt;{{employee.mail}}&gt;</a><br />
Phone: <a href="tel:{{employee.phone}}">{{employee.phone}}</a>
{%- if employee.matrix %}, Matrix: <a href="{{employee.matrix}}">@{{employee.matrix | split: '@' | last }}</a>{% endif %}<br />
{{employee.title}}<br />
<br /><img src="{{ "/assets/images/scs-signature.png" | prepend: site.baseurl_root }}" /><br /><br />
<small>
<a href="https://osb-alliance.com/">OSB Alliance - Bundesverband für digitale Souveränität e.V.</a><br />
Pariser Platz 6a, 10117 Berlin, Germany<br />
VR7217 (AG Stuttgart) - Chairman of the Board: Peter H. Ganten<br />
Sovereign Cloud Stack & SCS-Logo are protected trademarks of the OSB Alliance.</small>
<!-- End Signature {{employee.firstname}} -->
### Plain:
```

-- 
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}} - <{{employee.mail}}>
Phone: {{employee.phone}}{%- if employee.matrix %}, Matrix: @{{employee.matrix | split: '@' | last }}{% endif %}
{{employee.title}}

OSB Alliance - Bundesverband für digitale Souveränität e.V.
Pariser Platz 6a, 10117 Berlin, Germany
VR7217 (AG Stuttgart) - Chairman of the Board: Peter H. Ganten
Sovereign Cloud Stack & SCS-Logo are protected trademarks of the OSB Alliance.
```
<br /><br />
{% endfor %}

