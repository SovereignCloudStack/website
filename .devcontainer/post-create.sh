#!/bin/sh

# Install the version of Bundler.
if [ -f Gemfile.lock ] && grep "BUNDLED WITH" Gemfile.lock > /dev/null; then
    cat Gemfile.lock | tail -n 2 | grep -C2 "BUNDLED WITH" | tail -n 1 | xargs gem install bundler -v
fi

# If there's a Gemfile, then run `bundle update`
# It's assumed that the Gemfile will install Jekyll too
if [ -f Gemfile ]; then
    bundle update
fi

# Delete cache to prevent wrong paths if switching from local development to Dev Container
if [ -d .jekyll-cache ]; then
    rm -rf .jekyll-cache
fi

# Install npm modules
npm install
