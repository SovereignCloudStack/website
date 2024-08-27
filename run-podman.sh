#!/bin/bash

set -e
set -x

# Why use old versions? - Because the current way of deployment uses jekyll-action@v2, which uses these old versions as well.


# ----- npm stuff ----- #

# Build and run container for node_modules
podman build -t scs-test-jekyll:node16 --volume "$(pwd)":/data/:rw,Z -f Containerfile.node16 .



# ----- jekyll stuff ----- #

# Build container image for Jekyll
podman build -t scs-test-jekyll:action -f Containerfile.jekyll-action .

# Gems will be cached here
VENDOR_DIR=/tmp/jekyll-vendor
mkdir -p "$VENDOR_DIR"

# And build result will be cached here
BUILD_DIR=/tmp/jekyll-build
mkdir -p "$BUILD_DIR"

# Run podman with volume mounts (binds) and port forwarding for port 4000 (jekyll) and 35729 (live-reload script).
# Jekyll will be reachable via http://localhost:4000.
# If you have permission problems with the mounts, try "--user=0:0".
podman run -it --rm --name website-build \
    -p 4000:4000 -p 35729:35729 \
    --userns=keep-id:uid=1000,gid=1000 \
    -v $(pwd):/srv/jekyll:rw,Z \
    -v "$VENDOR_DIR":/tmp/jekyll-vendor:rw,Z \
    -v "$BUILD_DIR":/tmp/jekyll-build:rw,Z \
    scs-test-jekyll:action
