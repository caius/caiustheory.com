#!/usr/bin/env bash

set -e

# Copies a generated CaiusTheory up to the webserver

# Make sure we're compiled first, pass --no-compile as sole argument to skip
if [[ $1 != "--no-compile" ]]; then
  nanoc compile
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
  output/ nonus:www/caiustheory.com/htdocs
