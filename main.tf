terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
    rke = {
      source = "rancher/rke"
      version = "1.3.4"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    flux = {
      source = "fluxcd/flux"
      version = "0.22.2"
    }
    github = {
      source = "integrations/github"
      version = "5.12.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "github" {
  owner = var.flux_github_repo_owner
  token = var.flux_github_token
}