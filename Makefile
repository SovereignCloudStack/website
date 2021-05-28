# Makefile for the website

html: build

build: scripts/build.sh source/* source/css/* source/fonts/* source/images/* source/blog/* source/slides/*
	mkdir -p build
	touch build
	./scripts/build.sh

clean:
	rm -rf build

.PHONY: clean html
