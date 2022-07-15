---
layout: post
title:  "Improving and assuring the overall quality of the foundation of SCS"
author:
  - "Ramona Beermann"
avatar:
  - "avatar-osism.png"
image: "blog/corrections.jpg"
---

## Why this is done?

Uniform and well readable code increases readability, understandability, security, quality and reusability. Of course, this is nothing new for many. However, since every engineer and programmer has his own writing style and there are no clear guidelines everywhere, like with PEP8 for Python, regarding the order, especially with Ansible, it is often difficult to get uniform code.
Furthermore, we found that it can be very difficult to review code that has different structures and writing styles. For these reasons, we thought about how to achieve code consistency and make it last.

## What is done?

Now there is already a tool on the market that is supposed to do exactly that: Check code for its security and quality. This tool is Ansible Lint <https://github.com/ansible/ansible-lint>. In general, Ansible Lint already does exactly what we expect, but with a few limitations. Since it is possible to create custom rules there and load them quite easily, this was our way to the goal. We have previously defined within the OSISM project <https://github.com/osism> what exactly we expect from Ansible Lint, i.e. what it should check. We looked at what suggestions of sequences are shown in the Ansible documentation and what styles are the most common practice to use it as defaults for us. After that, we looked at the existing rules and then extended them with the features we needed. For us, for example, the order of the keywords was very important. Ansible Lint already has a rule that checks the position of the *name attribute*, but none in which you can define a list for yourself to check the order of the most important and security-critical attributes more precisely. Security-critical code is easier to keep track of, if every attribute is in the same position, since you can then very quickly detect if a value has been changed somewhere that opens doors and gates for attackers. However, this doesn't mean that critical code can't be loaded, but it makes it easier to check it for yourself. So we looked at Ansible Lint's **key-order** rule and extended it to pass a list with the order of the keywords:

```python

    import sys
    import os
    import yaml
    from typing import Any, Dict, Optional, Union

    from ansiblelint.file_utils import Lintable
    from ansiblelint.rules import AnsibleLintRule


    class OsismAttributeOrderRule(AnsibleLintRule):
        """Ensure specific order of attributes in mappings."""

        id = "osism-attribute-order"
        shortdesc = __doc__
        severity = "LOW"
        tags = ["formatting", "experimental"]
        version_added = "v6.3.0"
        needs_raw_task = True

        def matchtask(
            self, task: Dict[str, Any], file: Optional[Lintable] = None
        ) -> Union[bool, str]:

            with open(f"{os.getcwd()}/.ansible-lint-rules/osism_attribute_order_list.yaml", 'r') as fileStream:
                try:
                    osism_attribute_order_list = yaml.safe_load(fileStream)
                except yaml.YAMLError as exception:
                    print(exception)
                    sys.exit(0)

            raw_task = task["__raw_task__"]
            counter = 0
            counter_prev = 0
            for attribute in osism_attribute_order_list["osism_attribute_order_list"]:
                if attribute in raw_task:
                    attribute_list = [*raw_task]
                    counter = attribute_list.index(attribute)
                    if counter < counter_prev:
                        return f"{attribute_list[counter_prev]} is not at the right place"
                    else:
                        counter_prev = counter
            return False
```

Now you can store the order of the keywords which fits for yourself and your project, Ansible Lint checks them and generates an error in case of a discrepancy:

```yaml
---
osism_attribute_order_list:
    - name
    - become
    - when
```

For many, the topic of Ansible FQCN is still very controversial and unnecessary <https://github.com/ansible/ansible-lint/issues/2050>. We have decided that we will implement it, because we think the usage of the FQCN´s makes code safer. To check this, we have also extended the Ansible Lint **fqcn-builtins** rule to check a list. In this list you can now define all the collections you want to use, Ansible Lint then checks the code and throws a warning in case of error.

In order to pass these custom rules it is important to save them in the same directory as the .ansible file. The folder should be named **.ansible-lint-rules**. This must then be passed in the **.ansible** with the variable `rulesdir: /path/to/rules`. However, you should also take a look at the default rules of Ansible Lint. There are some that really make sense and that we now also use. To activate them, you have to pass this explicitly with the variable `use_default_rules: true`. This does not mean that you have to use all default rules. You can exclude rules that are not suitable for you from the check via the skip list or, if you only want to receive a warning, via the warning list.

We have now started to integrate these checks into all our GitHub repositories via GitHub Actions. So that when sources are modified or created in the future, it always complies with our specifications.

You can check a number of security critical aspects with Ansible Lint which does not mean that you are completely protected from everything. Like many other pieces of the puzzle, it only improves security. This in no way replaces the use of other security measures.

For more information on Ansible Lint and its functionality, please look at the documentation: <https://ansible-lint.readthedocs.io/en/latest/>.
