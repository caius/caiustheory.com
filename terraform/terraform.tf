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
      source = "vercel/vercel"
      version = "0.1.0"
    }
  }
}

provider "vercel" {
  api_token = var.vercel_token
}
