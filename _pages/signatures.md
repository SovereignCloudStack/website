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
### Langform
<!-- Begin Long Signature {{employee.firstname}} -->
\-\-<br />
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}<br />
{{employee.role}}<br />
<br />
Sovereign Cloud Stack — standardized, built and operated by many<br />
Ein Projekt der Open Source Business Alliance - Bundesverband für digitale Souveränität e.V.<br />
<br />
Tel.: {{employee.phone}}<br />
{% if employee.matrix %}Matrix: @{{employee.matrix | split: '@' | last }}{% endif %}<br />
{{employee.mail}}<br />
<br />
https://scs.community<br />
https://twitter.com/scs_osballiance<br />
https://www.linkedin.com/showcase/sovereigncloudstack<br />
<br />
Pariser Platz 6a, 10117 Berlin<br />
<br />
Vorstandsvorsitzender: Peter H. Ganten, Univention GmbH<br />
Stellvertretende Vorsitzende:<br />
Anja Stock<br />
Hong Phuc Dang<br />
Timo Levi, Deutsche Telekom AG<br />
Finanzvorstand: Diego Calvo de Nó, Proventa AG<br />
<br />
Ehrenvorsitzender: Dr. Karl Heinz Strassemeyer<br />
<br />
Registergericht: Amtsgericht Charlottenburg<br />
Registernummer: VR 39675 B<br />

<!-- End Long Signature {{employee.firstname}} -->
### Kurzform:
<!-- Begin Short Signature {{employee.firstname}} -->

\-\-<br />
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}<br />
{{employee.role}}<br />
<br />
Sovereign Cloud Stack — standardized, built and operated by many<br />
Ein Projekt der Open Source Business Alliance - Bundesverband für digitale Souveränität e.V.<br />
<br />
Tel.: {{employee.phone}} {% if employee.matrix %}\| Matrix: @{{employee.matrix | split: '@' | last }}{% endif %} \| {{employee.mail}}

<!-- End Short Signature {{employee.firstname}} -->
{% endfor %}
