data "template_file" "flux_namesapce" {
  template = "${file("${path.module}/namespace.tpl")}"
  vars = {
    namespace = "flux-system"
  }
}

locals {
  flux_yaml = <<-EOT
  ${data.template_file.flux_namespace.rendered}
  ${data.flux_install.main.content}
  ${data.flux_sync.main.content}
  EOT
}

resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true

  addons = local.flux_yaml

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
