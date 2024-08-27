#!/bin/bash

set -ex

mkdir -p /tmp/jekyll-build
mkdir -p /tmp/jekyll-vendor

bundle config path "/tmp/jekyll-vendor/vendor/bundle"
bundle config set force_ruby_platform true

# Change to jekyll directory and install from Gemfile
cd /srv/jekyll
bundle install

# Run jekyll serve, which includes build. Will be browsable on http://localhost:4000
# For more output, also add --verbose
JEKYLL_ENV=development bundle exec jekyll serve --trace --source /srv/jekyll --destination /tmp/jekyll-build --config _config.yml,_config.dev.yml --livereload --incremental --host 0.0.0.0
