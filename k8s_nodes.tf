resource "proxmox_pool" "namespace_pool" {
  poolid = format("k8s.%s", var.namespace)
}

module "controllers" {
  source = "git@github.com:pixil98/homelab-tfmod-vm.git?ref=initial-dev"

  count     = var.kubernetes_controller_count
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
  vm_user_publickey  = var.vm_user_publickey
  vm_user_privatekey = var.vm_user_privatekey

  puppet_git_repo = var.puppet_git_repo
  puppet_git_ref  = var.puppet_git_ref
  puppet_role     = "kubernetes::controller"
}

module "workers" {
  source = "git@github.com:pixil98/homelab-tfmod-vm.git?ref=initial-dev"

  count     = var.kubernetes_worker_count
  node      = var.nodes[count.index % length(var.nodes)]
  namespace = proxmox_pool.namespace_pool.poolid

  vm_name            = format("worker-%02d", count.index + 1)
  vm_description     = format("%s worker %d", var.namespace, count.index + 1)
  vm_cpu_cores       = 1
  vm_cpu_sockets     = 1
  vm_memory          = 16384
  vm_disk_size       = "30G"
  vm_network_address = var.kubernetes_worker_ips[count.index]
  vm_user            = var.vm_user
  vm_user_publickey  = var.vm_user_publickey
  vm_user_privatekey = var.vm_user_privatekey

  puppet_git_repo = var.puppet_git_repo
  puppet_git_ref  = var.puppet_git_ref
  puppet_role     = "kubernetes::worker"
}

resource "null_resource" "puppet" {
  for_each = toset(concat(module.controllers, module.workers))
  triggers = {
    user = var.vm_user
  }

  connection {
    type        = "ssh"
    user        = var.vm_user
    private_key = var.vm_user_privatekey
    host        = each.value.ip_address
    port        = 22
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo usermod -a -G docker ${var.vm_user}"
    ]
  }
}