# Makefile for the website

TARGETS = build/index.html.de build/index.html.en build/.htaccess build/robots.txt build/sitemap.xml build/blog/20200915-garloff-ovh.html.de build/blog/20200915-garloff-ovh.html.en

html: $(TARGETS) .dep

.dep: scripts/collectdeps.sh source/*
	./scripts/collectdeps.sh $(TARGETS) >$@

include .dep

build/%.html: source/%.html
	@mkdir -p build
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $<

build/%.html.de: source/%.html.de
	@mkdir -p build
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $<

build/%.html.en: source/%.html.en
	@mkdir -p build
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $<

build/%: source/%
	@mkdir -p build
	cp -p $< $@

build/blog/%: source/blog/%
	@mkdir -p build/blog
	cp -p $< $@

build/slides/%: source/slides/%
	@mkdir -p build/slides
	cp -p $< $@

build/css/%.css: source/css/%.css
	@mkdir -p build/css
	#cp -p $< $@
	cleancss -o $@ $<

build/fonts/%: source/fonts/%
	@mkdir -p build/fonts
	cp -p $< $@

build/images/%.png: source/images/%.png
	@mkdir -p build/images
	cp -p $< $@
	mogrify -depth 24 -define png:compression-filter=2 -define png:compression-level=9 \
		-define png:compression-strategy=1 -resize 75% $@

IMGSRC=source/images/SCS-Logo-832x832.png

build/favicon.ico: $(IMGSRC)
	@mkdir -p build
	convert $< -define icon:auto-resize=64,48,32,16 $@

build/images/favicon-32x32.png: $(IMGSRC)
	@mkdir -p build/images
	convert $< -resize 32x32 $@

build/images/favicon-96x96.png: $(IMGSRC)
	@mkdir -p build/images
	convert $< -resize 96x96 $@

build/images/apple-icon-180x180.png: $(IMGSRC)
	@mkdir -p build/images
	convert $< -resize 180x180 $@


clean:
	rm -rf build

.PHONY: clean html
