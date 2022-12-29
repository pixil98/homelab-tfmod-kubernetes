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
  }
}