# Makefile for the website

TARGETS = build/index.html.de build/index.html.en build/.htaccess build/robots.txt build/sitemap.xml build/blog/20200915-garloff-ovh.html.de build/blog/20200915-garloff-ovh.html.en

html: $(TARGETS) .dep

.dep: scripts/collectdeps.sh source/*
	./scripts/collectdeps.sh $(TARGETS) >$@

include .dep

build/%: source/%
	@mkdir -p build
	cp -p $< $@

build/blog/%: source/blog/%
	@mkdir -p build/blog
	cp -p $< $@


build: scripts/build.sh source/* source/css/* source/fonts/* source/images/* source/blog/* source/slides/*
	mkdir -p build
	touch build
	./scripts/build.sh

clean:
	rm -rf build

.PHONY: clean html
