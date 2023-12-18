terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "caius"

    workspaces {
      name = "caiustheory"
    }
  }

  required_version = "1.5.2"

  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "~> 0.1"
    }
  }
}

provider "vercel" {
  api_token = var.vercel_token
}
