terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source = "fluxcd/flux"
      version = "0.23.0"
    }
    github = {
      source = "integrations/github"
      version = "5.17.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}
