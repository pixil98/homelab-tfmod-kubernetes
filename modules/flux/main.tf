terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "0.25.3"
    }
    github = {
      source  = "integrations/github"
      version = "5.18.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}
