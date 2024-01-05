terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source = "fluxcd/flux"
      version = "1.2.2"
    }
    github = {
      source  = "integrations/github"
      version = "5.43.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    proxmox = {
      source = "bpg/proxmox"
      version = "0.43.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.4.3"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "flux" {
  kubernetes = {
    host                   = rke_cluster.cluster.api_server_url
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

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_user
  password = var.proxmox_password
}
