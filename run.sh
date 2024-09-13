#!/bin/bash

set -e
open http://127.0.0.1:4000
set -x

# https://github.com/envygeeks/jekyll-docker/blob/master/README.md

docker build -t scs-test-jekyll -f Dockerfile .
docker run -it --rm -p 4000:4000 \
   --network host \
   -e TARGET_UID="$(id -u)" -e TARGET_GID="$(id -g)" \
   -e LC_ALL=C.UTF-8 \
   -e LANG=C.UTF-8 \
   -e USER_ID="$(id -u)" \
   --volume="$PWD:/srv/jekyll:Z" \
   scs-test-jekyll\
   serve
