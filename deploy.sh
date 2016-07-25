#!/usr/bin/env bash

set -e
set -x

# Copies a generated CaiusTheory up to the webserver

bundle check || bundle install

# Make sure we're compiled first, pass --no-compile as sole argument to skip
if [[ $1 != "--no-compile" ]]; then
  rm -rf build/
  bundle exec middleman build --verbose
fi

# Deploy to webserver!
rsync \
  --rsh=ssh \
  --archive \
  --partial \
  --progress \
  --compress \
  --delay-updates \
  --delete-after \
  build/ nonus:www/caiustheory.com/htdocs
