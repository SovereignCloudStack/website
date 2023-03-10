#!/bin/bash

# Install dependencies fdor jekyll-asset pipeline
sudo apt update
sudo apt install libvips-tools uglifyjs -y

# Update bundler
gem update bundler

# Install and update bundled Ruby gems
bundle update
