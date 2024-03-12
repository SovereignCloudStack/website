#!/bin/bash

set -e
open http://127.0.0.1:4000
set -x
docker build -t scs-test-jekyll -f Dockerfile .
docker run -it --rm -p 4000:4000 \
   --network host \
   -e TARGET_UID="$(id -u)" -e TARGET_GID="$(id -g)" \
   -e LC_ALL=C.UTF-8 \
   -e LANG=C.UTF-8 \
   -e USER_ID="$(id -u)" \
   -v $(pwd):/site scs-test-jekyll $@
