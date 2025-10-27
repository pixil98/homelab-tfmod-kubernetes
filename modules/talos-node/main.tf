terraform {
  required_version = ">= 1.3.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.1"
    }
  }
}