terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.0.0-rc.1"
    }
    github = {
      source  = "integrations/github"
      version = "5.23.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}
