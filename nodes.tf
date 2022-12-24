resource "proxmox_pool" "namespace_pool" {
  poolid = format("k8s.%s", var.namespace)
}

module "controller" {
  source = "git@github.com:pixil98/homelab-tfmod-vm.git?ref=initial-dev"
  providers = {
    proxmox = proxmox
   }

  count     = var.kubernetes_controller_count
  node      = "luke"
  namespace = proxmox_pool.namespace_pool.poolid

  vm_name            = format("controller-%02d", count.index + 1)
  vm_description     = format("controller-%02d", count.index + 1)
  vm_cpu_cores       = 1
  vm_cpu_sockets     = 1
  vm_memory          = 4096
  vm_disk_size       = "10G"
  vm_network_address = format("192.168.1.%d", 50 + count.index)
  vm_user            = var.vm_user
  vm_user_pubkey     = var.vm_user_pubkey
}

module "worker" {
  source = "git@github.com:pixil98/homelab-tfmod-vm.git?ref=initial-dev"
  providers = {
    proxmox = proxmox
   }

  count     = var.kubernetes_worker_count
  node      = "luke"
  namespace = proxmox_pool.namespace_pool.poolid

  vm_name            = format("worker-%02d", count.index + 1)
  vm_description     = format("worker-%02d", count.index + 1)
  vm_cpu_cores       = 1
  vm_cpu_sockets     = 1
  vm_memory          = 16384
  vm_disk_size       = "30G"
  vm_network_address = format("192.168.1.%d", 60 + count.index)
  vm_user            = var.vm_user
  vm_user_pubkey     = var.vm_user_pubkey
}