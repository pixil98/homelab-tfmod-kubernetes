terraform {
  required_version = ">= 1.3.6"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.7.3"
    }
    github = {
      source  = "integrations/github"
      version = "6.7.1"
    }
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_user
  password = var.proxmox_password
}

provider "flux" {
  kubernetes = {
    host                   = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
    client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
  }
  git = {
    url    = "https://git@github.com/${var.flux_github_repo_owner}/${var.flux_github_repo_name}.git"
    branch = var.namespace
    http = {
      username = "git"
      password = var.flux_github_token
    }
  }
}

provider "github" {
  owner = var.flux_github_repo_owner
  token = var.flux_github_token
}

provider "kubernetes" {
  host                   = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
  client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
}

provider "kubectl" {
  host                   = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
  client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
  load_config_file       = false
}
