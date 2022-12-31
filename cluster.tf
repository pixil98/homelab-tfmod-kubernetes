resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true

  ingress {
    provider = "none"
  }

  upgrade_strategy {
      drain = true
      max_unavailable_worker = "20%"
  }

  dynamic "nodes" {
    for_each = module.controllers
    content {
      address = nodes.value.ip_address
      internal_address = nodes.value.ip_address
      user = var.vm_user
      role = ["controlplane", "etcd"]
      ssh_key = var.vm_user_privatekey
    }
  }
  dynamic "nodes" {
    for_each = module.workers
    content {
      address = nodes.value.ip_address
      internal_address = nodes.value.ip_address
      user = var.vm_user
      role = ["worker"]
      ssh_key = var.vm_user_privatekey
    }
  }
}

resource "local_sensitive_file" "kubeconfig" {
  filename = "${path.root}/kubeconfig"
  content  = "${rke_cluster.cluster.kube_config_yaml}"
}