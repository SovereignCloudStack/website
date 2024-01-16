#!/bin/sh

set -x -e
cd /site

#adduser  -u $USER_ID -D -h /site build
bundle update
bundle install
jekyll serve config _config.yml,_config.dev.yml  --incremental -H 0.0.0.0

