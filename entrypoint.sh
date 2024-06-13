#!/bin/bash


if [ -z "$TARGET_UID" ];then
   echo "ERROR: ENVIRONMENT VARIABLE TARGET_UID IS NOT PROVIDED"
   exit 1
fi
if [ -z "$TARGET_GID" ];then
   echo "ERROR: ENVIRONMENT VARIABLE TARGET_GID IS NOT PROVIDED"
   exit 1
fi

set -x

if [ "$1" = "/bin/bash" ];then
  echo entering shell
  cd /srv/jekyll
  exec /bin/bash
fi

cd /srv/jekyll
bundle config set force_ruby_platform true
#bundle update
bundle install
jekyll serve config _config.yml,_config.dev.yml  --incremental -H 0.0.0.0
