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
<!-- Begin Short Signature {{employee.firstname}} -->
```
--
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}
{{employee.role}}

Sovereign Cloud Stack — standardized, built and operated by many
Ein Projekt der Open Source Business Alliance - Bundesverband für digitale Souveränität e.V.

Tel.: {{employee.phone}}
{% if employee.matrix %}Matrix: @{{employee.matrix | split: '@' | last }}{% endif %}
{{employee.mail}}

https://scs.community
https://twitter.com/scs_osballiance
https://www.linkedin.com/showcase/sovereigncloudstack

Pariser Platz 6a, 10117 Berlin

Vorstandsvorsitzender: Peter H. Ganten, Univention GmbH
Stellvertretende Vorsitzende:
Anja Stock, SUSE Software Solutions Germany GmbH
Hong Phuc Dang
Timo Levi, Deutsche Telekom AG
Finanzvorstand: Diego Calvo de Nó, Proventa AG

Ehrenvorsitzender: Dr. Karl Heinz Strassemeyer

Registergericht: Amtsgericht Charlottenburg
Registernummer: VR 39675 B
```
<!-- End Short Signature {{employee.firstname}} -->
### Kurzform:
<!-- Begin Short Signature {{employee.firstname}} -->
```
--
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}}
{{employee.role}}

Sovereign Cloud Stack — standardized, built and operated by many
Ein Projekt der Open Source Business Alliance - Bundesverband für digitale Souveränität e.V.

Tel.: {{employee.phone}} {% if employee.matrix %}| Matrix: @{{employee.matrix | split: '@' | last }}{% endif %} | {{employee.mail}}
```
<!-- End Short Signature {{employee.firstname}} -->
<br /><br />
{% endfor %}
