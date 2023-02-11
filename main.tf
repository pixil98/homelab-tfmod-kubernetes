terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.13"
    }
    rke = {
      source = "rancher/rke"
      version = "1.3.4"
    }
    local = {
      source = "hashicorp/local"
      version = "2.3.0"
    }
    github = {
      source = "integrations/github"
      version = "5.17.0"
    }
  }
}

provider "github" {
  owner = var.flux_github_repo_owner
  token = var.flux_github_token
}
