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
    flux = {
      source = "fluxcd/flux"
      version = "1.2.2"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
  }
}

provider "flux" {
  kubernetes = {
    host                   = rke_cluster.cluster.control_plane_hosts[0].address
    client_certificate     = rke_cluster.cluster.client_cert
    client_key             = rke_cluster.cluster.client_key
    cluster_ca_certificate = rke_cluster.cluster.ca_crt
  }
  git = {
    url    = "ssh://git@github.com/${var.flux_github_repo_owner}/${var.flux_github_repo_name}.git"
    branch = var.flux_github_branch
    ssh    = {
      username    = "git"
      private_key = var.vm_user_privatekey
    }
  }
}

provider "github" {
  owner = var.flux_github_repo_owner
  token = var.flux_github_token
}
