terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "caius"

    workspaces {
      name = "caiustheory"
    }
  }
}
