#!/usr/bin/env bash

# Migrates from nanoc blog posts to middleman blog posts

set -e
set -x

if [[ -e content/posts ]]
then
  echo "Not updating posts - content/posts/ exists and we might overwrite data!"
  exit 1
fi

git checkout master -- content/posts

for post in content/posts/*
do
  middleman_post="$(echo $post | sed -e 's/content/source/' -e 's/\.md/\.html\.md/')"
  git mv -f "$post" "$middleman_post"
  sed -i '' -Ee 's/created_at: /date: /' -e '/updated_at: /d' "$middleman_post"
  git add "$middleman_post"
done

rm -rf content/posts
