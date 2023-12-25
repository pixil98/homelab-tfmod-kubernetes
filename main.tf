terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.42.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.4.3"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
  }
}

provider "github" {
  owner = var.flux_github_repo_owner
  token = var.flux_github_token
}
