resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true

  ingress {
    provider = "none"
  }

  dynamic "nodes" {
    for_each = module.controllers
    content {
      address = each.ip_address
      internal_address = each.ip_address
      user = var.vm_user
      role = ["controlplane", "etcd"]
      ssh_key = var.vm_user_privatekey
    }
  }
  dynamic "nodes" {
    for_each = module.workers
    content {
      address = each.ip_address
      internal_address = each.ip_address
      user = var.vm_user
      role = ["worker"]
      ssh_key = var.vm_user_privatekey
    }
  }
}