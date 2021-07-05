# Makefile for the website

TARGETS = build/index.html.de build/index.html.en build/.htaccess build/robots.txt build/sitemap.xml build/blog/20200915-garloff-ovh.html.de build/blog/20200915-garloff-ovh.html.en

html: $(TARGETS) .dep

.dep: scripts/collectdeps.sh source/*
	./scripts/collectdeps.sh $(TARGETS) >$@

include .dep

build/%.html: source/%.html
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $<

build/%.html.de: source/%.html.de
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $<

build/%.html.en: source/%.html.en
	@PTH="$@"; mkdir -p $${PTH%/*}
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $<

build/%.html.de: source/%.de.md source/header_de.html source/footer_de.html Makefile
	@PTH="$@"; mkdir -p $${PTH%/*}
	cat source/header_de.html > $@
	#MultiMarkdown-6-mmd $<; IN="$<"; cat $${IN%.md}.html >> $@; rm $${IN%.md}.html
	markdown_py $< >>$@
	sed -i 's/<p>/<p class="lead">/g' $@
	TITLE=$$(grep '^#' $< | head -n1 | sed 's/^#*//'); sed -i "s/<title>Sovereign Cloud Stack/<title>SCS: $${TITLE}/" $@
	cat source/footer_de.html >> $@
	DOC="$@"; DOC="$${DOC%.de}"; sed -i "s@index.html.en@$${DOC#build/}.en@" $@
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $@

build/%.html.en: source/%.en.md source/header_en.html source/footer_en.html Makefile
	@PTH="$@"; mkdir -p $${PTH%/*}
	cat source/header_en.html > $@
	#MultiMarkdown-6-mmd $<; IN="$<"; cat $${IN%.md}.html >> $@; rm $${IN%.md}.html
	markdown_py $< >>$@
	sed -i 's/<p>/<p class="lead">/g' $@
	TITLE=$$(grep '^#' $< | head -n1 | sed 's/^#*//'); sed -i "s/<title>Sovereign Cloud Stack/<title>SCS: $${TITLE}/" $@
	cat source/footer_en.html >> $@
	DOC="$@"; DOC="$${DOC%.en}"; sed -i "s@index.html.de@$${DOC#build/}.de@" $@
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $@

build/%.html: source/%.md source/header_en.html source/footer_en.html Makefile
	@PTH="$@"; mkdir -p $${PTH%/*}
	cat source/header_en.html > $@
	#MultiMarkdown-6-mmd $<; IN="$<"; cat $${IN%.md}.html >> $@; rm $${IN%.md}.html
	markdown_py $< >>$@
	sed -i 's/<p>/<p class="lead">/g' $@
	TITLE=$$(grep '^#' $< | head -n1 | sed 's/^#*//'); sed -i "s/<title>Sovereign Cloud Stack/<title>SCS: $${TITLE}/" $@
	cat source/footer_en.html >> $@
	html-minifier \
	    --collapse-whitespace --use-short-doctype \
	    --remove-comments --remove-redundant-attributes --remove-script-type-attributes \
	    --minify-css true --minify-js true \
	    --output $@ $@

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
