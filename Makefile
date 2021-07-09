# Makefile for the website
# Author: Kurt Garloff <scs@garloff.de>
# Copyright: 7/2020 - 3/2021 KG IT Consulting
# Copyright: 4/2021 - 7/2021 OSB Alliance e.V.
# SPDX-License-Identifier: CC-BY-SA-4.0

#SOURCES = $(wildcard source/*.html) $(wildcard source/*.html.en) $(wildcard source/*.html.de)
#TARGETS = $(subst source,build,$(SOURCES)) build/.htaccess build/robots.txt build/sitemap.xml build/blog/20200915-garloff-ovh.html.de build/blog/20200915-garloff-ovh.html.en

TARGETS = build/index.html.de build/index.html.en build/.htaccess build/robots.txt build/sitemap.xml build/blog/20200915-garloff-ovh.html.de build/blog/20200915-garloff-ovh.html.en

html: $(TARGETS) .dep

.dep: scripts/collectdeps.py source/* source/css/styles.css Makefile
	./$< $(TARGETS) build/test.html.de build/test.html.en >$@

include .dep

HTML_MINI_ARGS = --collapse-whitespace --use-short-doctype \
            --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
            --minify-css true --minify-js true

build/%.html: source/%.html
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier $(HTML_MINI_ARGS) --output $@ $<

build/%.html.de: source/%.html.de
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier $(HTML_MINI_ARGS) --output $@ $<

build/%.html.en: source/%.html.en
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier $(HTML_MINI_ARGS) --output $@ $<

build/%.html: tmp/%.html
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier $(HTML_MINI_ARGS) --output $@ $<

build/%.html.de: tmp/%.html.de
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier $(HTML_MINI_ARGS) --output $@ $<

build/%.html.en: tmp/%.html.en
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier $(HTML_MINI_ARGS) --output $@ $<

tmp/%.html.de: source/%.de.md source/header_de.html source/footer_de.html Makefile
	#@PTH="$@"; mkdir -p $${PTH%/*}
	cat source/header_de.html > $@
	#MultiMarkdown-6-mmd $<; IN="$<"; cat $${IN%.md}.html >> $@; rm $${IN%.md}.html
	markdown_py -x toc -x meta -x tables $< >>$@
	sed -i 's/<p>/<p class="lead">/g' $@
	TITLE=$$(grep '^#' $< | head -n1 | sed 's/^#*//'); sed -i "s/<title>Sovereign Cloud Stack/<title>SCS: $${TITLE}/" $@
	cat source/footer_de.html >> $@
	DOC="$@"; DOC="$${DOC%.de}"; sed -i "s@index.html.en@$${DOC#tmp/}.en@" $@

tmp/%.html.en: source/%.en.md source/header_en.html source/footer_en.html Makefile
	@PTH="$@"; mkdir -p $${PTH%/*}
	cat source/header_en.html > $@
	#MultiMarkdown-6-mmd $<; IN="$<"; cat $${IN%.md}.html >> $@; rm $${IN%.md}.html
	markdown_py -x toc -x meta -x tables $< >>$@
	sed -i 's/<p>/<p class="lead">/g' $@
	TITLE=$$(grep '^#' $< | head -n1 | sed 's/^#*//'); sed -i "s/<title>Sovereign Cloud Stack/<title>SCS: $${TITLE}/" $@
	cat source/footer_en.html >> $@
	DOC="$@"; DOC="$${DOC%.en}"; sed -i "s@index.html.de@$${DOC#tmp/}.de@" $@

tmp/%.html: source/%.md source/header_en.html source/footer_en.html Makefile
	@PTH="$@"; mkdir -p $${PTH%/*}
	cat source/header_en.html > $@
	#MultiMarkdown-6-mmd $<; IN="$<"; cat $${IN%.md}.html >> $@; rm $${IN%.md}.html
	markdown_py -x toc -x meta -x tables $< >>$@
	sed -i 's/<p>/<p class="lead">/g' $@
	TITLE=$$(grep '^#' $< | head -n1 | sed 's/^#*//'); sed -i "s/<title>Sovereign Cloud Stack/<title>SCS: $${TITLE}/" $@
	cat source/footer_en.html >> $@


# TODO: Add rst -> html conversion as well

build/css/%.css: source/css/%.css
	@mkdir -p build/css
	#cp -p $< $@
	cleancss -o $@ $<

build/images/%.png: source/images/%.png
	@mkdir -p build/images
	cp -p $< $@
	mogrify -depth 24 -define png:compression-filter=2 -define png:compression-level=9 \
		-define png:compression-strategy=1 -resize 75% $@

build/%: source/%
	@PTH="$@"; mkdir -p $${PTH%/*}
	cp -p $< $@

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
