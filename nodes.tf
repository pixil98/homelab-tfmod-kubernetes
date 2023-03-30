resource "proxmox_pool" "namespace_pool" {
  poolid = format("k8s.%s", var.namespace)
}

module "controllers" {
  source = "github.com/pixil98/homelab-tfmod-vm.git?ref=main"

  count     = length(var.kubernetes_controller_ips)
  node      = var.nodes[count.index % length(var.nodes)]
  namespace = proxmox_pool.namespace_pool.poolid

  vm_name            = format("controller-%02d", count.index + 1)
  vm_description     = format("%s controller %d", var.namespace, count.index + 1)
  vm_cpu_cores       = 1
  vm_cpu_sockets     = 1
  vm_memory          = 4096
  vm_disk_size       = "10G"
  vm_network_address = var.kubernetes_controller_ips[count.index]
  vm_user            = var.vm_user
  vm_user_privatekey = var.vm_user_privatekey

  puppet_git_repo = var.puppet_git_repo
  puppet_git_ref  = var.puppet_git_ref
  puppet_role     = "kubernetes::controller"
}

module "workers" {
  source = "github.com/pixil98/homelab-tfmod-vm.git?ref=main"

  count     = length(var.kubernetes_worker_ips)
  node      = var.nodes[count.index % length(var.nodes)]
  namespace = proxmox_pool.namespace_pool.poolid

  vm_name            = format("worker-%02d", count.index + 1)
  vm_description     = format("%s worker %d", var.namespace, count.index + 1)
  vm_cpu_cores       = 4
  vm_cpu_sockets     = 2
  vm_memory          = 16384
  vm_disk_size       = "30G"
  vm_network_address = var.kubernetes_worker_ips[count.index]
  vm_user            = var.vm_user
  vm_user_privatekey = var.vm_user_privatekey

  puppet_git_repo = var.puppet_git_repo
  puppet_git_ref  = var.puppet_git_ref
  puppet_role     = "kubernetes::worker"
}
