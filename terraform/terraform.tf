terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "caius"

    workspaces {
      name = "caiustheory"
    }
  }
}

terraform {
  required_providers {
    vercel = {
      source = "chronark/vercel"
      version = "0.14.4"
    }
  }
}

provider "vercel" {
  token = var.vercel_token
}
