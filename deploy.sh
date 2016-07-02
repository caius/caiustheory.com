#!/usr/bin/env bash

set -e

# Copies a generated CaiusTheory up to the webserver

# Make sure we're compiled first, pass --no-compile as sole argument to skip
if [[ $1 != "--no-compile" ]]; then
  rm -rf build/
  bundle exec middleman build --verbose
fi

# Deploy to webserver!
rsync \
  --dry-run \
  --rsh=ssh \
  --archive \
  --partial \
  --progress \
  --compress \
  --delay-updates \
  --delete-after \
  build/ nonus:www/caiustheory.com/htdocs
