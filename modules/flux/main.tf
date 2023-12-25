terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.2.2"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}
