resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true

  ingress {
    provider = "none"
  }

  dynamic "nodes" {
    for_each = var.kubernetes_controller_ips
    content {
      address = each.value
      internal_address = each.value
      user = var.vm_user
      role = ["controlplane", "etcd"]
      ssh_key = var.vm_user_privatekey
    }
  }
  dynamic "nodes" {
    for_each = var.kubernetes_worker_ips
    content {
      address = each.value
      internal_address = each.value
      user = var.vm_user
      role = ["worker"]
      ssh_key = var.vm_user_privatekey
    }
  }
}