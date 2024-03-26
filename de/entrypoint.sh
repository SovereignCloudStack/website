#!/bin/bash

if [ "$1" = "/bin/bash" ];then
  exec /bin/bash
fi

if [ -z "$TARGET_UID" ];then
   echo "ERROR: ENVIRONMENT VARIABLE TARGET_UID IS NOT PROVIDED"
   exit 1
fi
if [ -z "$TARGET_GID" ];then
   echo "ERROR: ENVIRONMENT VARIABLE TARGET_GID IS NOT PROVIDED"
   exit 1
fi

set -x
echo $PATH
adduser  -u $USER_ID -D -h /site build

su -c "sh -s" - build <<'EOF'
set -x
umask 0077
cd /site
bundle update
bundle install
jekyll serve config _config.yml,_config.dev.yml  --incremental -H 0.0.0.0
EOF
