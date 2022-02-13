/*resource "vercel_domain" "caiustheory-com" {
  name = "caiustheory.com"
}*/

resource "vercel_project" "caiustheory" {
  name = "caiustheory"

  git_repository {
    type = "github"
    repo = "caius/caiustheory.com"
  }
}
