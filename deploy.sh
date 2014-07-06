#!/usr/bin/env bash

rsync -aP --delete-after output/ brutus:www/static.caiustheory.com/htdocs
