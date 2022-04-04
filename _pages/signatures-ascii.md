---
title: Mail Signatures
permalink: /signatures-ascii
---
{% for employee in site.data.employees %}

```
8=>--------------------------------------

-- 
{% if employee.academic %}{{employee.academic}} {% endif %}{{employee.firstname}} {{employee.lastname}} - {{employee.mail}}
Phone: {{employee.phone}}{%- if employee.matrix %}, Matrix: {{employee.matrix | split: '@' | last }}{% endif %}
{{employee.title}}

OSB Alliance - Bundesverband für digitale Souveränität e.V.
Pariser Platz 6a, 10117 Berlin, Germany
VR7217 (AG Stuttgart) - Chairman of the Board: Peter H. Ganten
Sovereign Cloud Stack & SCS-Logo are protected trademarks of the OSB Alliance.
```

{% endfor %}
