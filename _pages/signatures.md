---
title: Mail Signatures
permalink: /signatures
---
<head>
<meta charset="UTF-8">
<meta name="robots" content="none" />
</head>
# E-Mail Signatures
{% for employee in site.employees %}
## {{employee.firstname}}:
### HTML:
<!-- Begin Signature {{employee.firstname}} -->
<b>{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}</b><br />
{{employee.role}}<br />
Phone: {{employee.phone}}
{%- if employee.matrix %}, Matrix: @{{employee.matrix | split: '@' | last }}{% endif %}

<br />{% asset 'scs-signature.png' %}<br /><br />
<small>
OSB Alliance - Bundesverband für digitale Souveränität e.V.<br />
Pariser Platz 6a, 10117 Berlin, Germany<br />
VR 39675 B (AG Charlottenburg) - Chairman of the Board: Peter H. Ganten</small>
<!-- End Signature {{employee.firstname}} -->
### Plain:
```
--
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}
{{employee.role}}
Phone: {{employee.phone}}{%- if employee.matrix %}, Matrix: @{{employee.matrix | split: '@' | last }}{% endif %}

Join our community: https://scs.community

SCS is a project of
 | OSB Alliance - Bundesverband für digitale Souveränität e.V.
 | Pariser Platz 6a, 10117 Berlin, Germany
 | VR 39675 B (AG Charlottenburg) - Chairman of the Board: Peter H. Ganten
```

### Plain #2:
```
--
 __  __ __   
/ _|/ _/ _|  {% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}
\_ ( (_\_ \  {{employee.role}}
|__/\__|__/  Phone: {{employee.phone}}{%- if employee.matrix %}, Matrix: @{{employee.matrix | split: '@' | last }}{% endif %}

Sovereign Cloud Stack (SCS) is federated cloud technology built entirely with
Open Source Software — putting users and providers in control.

Join our community: https://scs.community

SCS is a project of
 | OSB Alliance - Bundesverband für digitale Souveränität e.V.
 | Pariser Platz 6a, 10117 Berlin, Germany
 | VR 39675 B (AG Charlottenburg) - Chairman of the Board: Peter H. Ganten
```
<br /><br />
{% endfor %}
