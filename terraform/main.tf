resource "vercel_project" "caiustheory" {
  name = "caiustheory"
  framework = "hugo"

  # baseURL magic builds with SITE_URL if set, if not then VERCEL_URL
  build_command = "hugo --gc --minify --baseURL https://$${SITE_URL:-$$VERCEL_URL}}/ $${BUILD_ENV_ARGS}"

  environment = [
    # Preview builds drafts/expired/future posts
    {
      key = "BUILD_ENV_ARGS"
      value = "--buildDrafts --buildExpired --buildFuture"
      target = [
        "development",
        "preview"
      ]
    },
    # Production builds point at caiustheory.com
    {
      key = "SITE_URL"
      value = "caiustheory.com"
      target = [
        "production"
      ]
    }
  ]

  git_repository = {
    type = "github"
    repo = "caius/caiustheory.com"
  }
}