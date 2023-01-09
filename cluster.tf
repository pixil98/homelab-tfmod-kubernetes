locals {
  addons = <<-EOT
  ${length(module.flux) > 0 ? module.flux[0].yaml : ""}
  ${length(var.sealed_secrets_key) > 0 ?  templatefile("${path.module}/sealed_secrets.tftpl", { 
    key_base64 = base64encode(var.sealed_secrets_key)
    crt_base64 = base64encode(var.sealed_secrets_crt)
  }) : ""}
  EOT
}

resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true

  addons = local.addons

  ingress {
    provider     = "none"
    http_port    = 80 
    https_port   = 443
    network_mode = "hostPort"
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
  content  = rke_cluster.cluster.kube_config_yaml
  directory_permission = "0700"
  file_permission = "0600"
}
