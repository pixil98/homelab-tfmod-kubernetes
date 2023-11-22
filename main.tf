terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source  = "loeken/proxmox"
      version = "2.9.16"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.4.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
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
