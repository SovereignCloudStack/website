# Primary Makefile
# Contains enough logic to call 2ndary Makefile
# 
# (w) Kurt Garloff <garloff@osb-alliance.com>, 7/2021
# (c) OSB Alliance e.V.
# SPDX-License-Identifier: CC-BY-SA-4.0

default: html

DEPTARGETS = build/index.html.de build/index.html.en

.dep: scripts/collectdeps.py source/* source/css/styles.css Makefile tmp/logos.html
	./$< $(DEPTARGETS) >$@

tmp/logos.html: scripts/gen-logos.py source/logos.yaml
	@mkdir -p tmp
	$^ > $@

%:
	$(MAKE) .dep	
	$(MAKE) -f Makefile.2nd $@

.PHONY: default
