resource "vercel_project" "caiustheory" {
  name      = "caiustheory"
  framework = "hugo"

  # baseURL magic builds with SITE_URL if set, if not then VERCEL_URL
  build_command = "hugo --gc --minify --baseURL https://$${SITE_URL:-$VERCEL_URL}/ $${BUILD_ENV_ARGS}"

  environment = [
    # Production builds are in production env
    {
      key   = "HUGO_ENV"
      value = "production"
      target = [
        "production"
      ]
    },
    # Preview builds are in development env
    {
      key   = "HUGO_ENV"
      value = "development"
      target = [
        "development",
        "preview"
      ]
    },
    # Pin hugo version used for deployments
    {
      key   = "HUGO_VERSION"
      value = "0.119.0"
      target = [
        "development",
        "preview",
        "production"
      ]
    },
    # Preview builds drafts/expired/future posts
    {
      key   = "BUILD_ENV_ARGS"
      value = "--buildDrafts --buildExpired --buildFuture"
      target = [
        "development",
        "preview"
      ]
    },
    # Production builds point at caiustheory.com
    {
      key   = "SITE_URL"
      value = "caiustheory.com"
      target = [
        "production"
      ]
    },
  ]

  git_repository = {
    type = "github"
    repo = "caius/caiustheory.com"
  }
}

resource "vercel_project_domain" "caiustheory-com" {
  project_id = vercel_project.caiustheory.id
  domain     = "caiustheory.com"
}

resource "vercel_project_domain" "www-caiustheory-com" {
  project_id = vercel_project.caiustheory.id
  domain     = "www.caiustheory.com"

  redirect             = vercel_project_domain.caiustheory-com.domain
  redirect_status_code = 308
}
