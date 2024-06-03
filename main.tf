terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source = "fluxcd/flux"
      version = "1.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }
    jq = {
      source = "massdriver-cloud/jq"
      version = "0.2.1"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    proxmox = {
      source = "bpg/proxmox"
      version = "0.58.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.5.0"
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

provider "kubectl" {
  host                   = rke_cluster.cluster.api_server_url
  client_certificate     = rke_cluster.cluster.client_cert
  client_key             = rke_cluster.cluster.client_key
  cluster_ca_certificate = rke_cluster.cluster.ca_crt
  load_config_file       = false
}

provider "kubernetes" {
  host                   = rke_cluster.cluster.api_server_url
  client_certificate     = rke_cluster.cluster.client_cert
  client_key             = rke_cluster.cluster.client_key
  cluster_ca_certificate = rke_cluster.cluster.ca_crt
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_user
  password = var.proxmox_password
}
