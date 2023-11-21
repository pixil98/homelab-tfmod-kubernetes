resource "proxmox_pool" "namespace_pool" {
  poolid = format("k8s.%s", var.namespace)
}

module "controllers" {
  source = "github.com/pixil98/homelab-tfmod-vm.git?ref=main"

  count     = length(var.kubernetes_controller_ips)
  node      = var.nodes[count.index % length(var.nodes)]
  namespace = proxmox_pool.namespace_pool.poolid

  vm_name            = format("%s-controller-%02d", var.namespace, count.index + 1)
  vm_description     = format("%s controller %d", var.namespace, count.index + 1)
  vm_disk_class      = var.vm_disk_class
  vm_cpu_cores       = var.kubernetes_controller_cpu_cores
  vm_cpu_sockets     = var.kubernetes_controller_cpu_sockets
  vm_memory          = var.kubernetes_controller_memory
  vm_disk_size       = var.kubernetes_controller_disk_size
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

  vm_name            = format("%s-worker-%02d", var.namespace, count.index + 1)
  vm_description     = format("%s worker %d", var.namespace, count.index + 1)
  vm_disk_class      = var.vm_disk_class
  vm_cpu_cores       = var.kubernetes_worker_cpu_cores
  vm_cpu_sockets     = var.kubernetes_worker_cpu_sockets
  vm_memory          = var.kubernetes_worker_memory
  vm_disk_size       = var.kubernetes_worker_disk_size
  vm_network_address = var.kubernetes_worker_ips[count.index]
  vm_user            = var.vm_user
  vm_user_privatekey = var.vm_user_privatekey

  puppet_git_repo = var.puppet_git_repo
  puppet_git_ref  = var.puppet_git_ref
  puppet_role     = "kubernetes::worker"
}
