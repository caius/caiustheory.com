#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o noclobber
set -o xtrace

# Everywhere:
#   HUGO_VERSION=0.92.2
#
# Production: (VERCEL_ENV=production)
#   HUGO_ENV=production
#   SITE_URL=caiustheory.com
#
# Preview, Development: (VERCEL_ENV=preview, VERCEL_ENV=development)
#   HUGO_ENV=development
#   BUILD_ENV_ARGS="--buildDrafts --buildExpired --buildFuture"
#

# https://vercel.com/docs/projects/environment-variables/system-environment-variables
# VERCEL=1 if exposed
# VERCEL_ENV=(production|preview|development)
# VERCEL_URL=*.vercel.app
# VERCEL_BRANCH_URL=*-git-*.vercel.app
#

if [[ ! "${VERCEL:-}" = "1" ]]; then
  echo "Vercel project isn't injecting generated environment variables. Please enable in project settings."
  exit 2
fi

# Force base url in production
if [[ "${VERCEL_ENV}" = "production" ]]; then
  SITE_HOST="caiustheory.com"
else
  SITE_HOST="${VERCEL_URL}"
fi
readonly SITE_HOST

exec hugo --gc --minify --baseURL "https://${SITE_HOST}/"
