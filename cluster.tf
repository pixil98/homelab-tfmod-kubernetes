locals {
  cluster_name     = "${var.namespace}-k8s-cluster"
  controlplane_ips = sort([for c in module.controlplanes : c.ip_address])
  worker_ips       = sort([for w in module.workers : w.ip_address])
  cluster_endpoint = "https://${local.controlplane_ips[0]}:6443"

  config_patches = [
    yamlencode({
      cluster = {
        apiServer = {
          extraArgs = {
            feature-gates  = "MutatingAdmissionPolicy=true"
            runtime-config = "admissionregistration.k8s.io/v1beta1=true"
          }
        }
      }
      machine = {
        kubelet = {
          extraConfig = {
            containerLogMaxSize  = var.kubernetes_container_log_max_size
            containerLogMaxFiles = var.kubernetes_container_log_max_files
          }
        }
        registries = {
          mirrors = {
            "docker.io" = {
              endpoints    = ["https://registry.lab.reisman.org/v2/proxy.docker.io"]
              overridePath = true
            }
            "gcr.io" = {
              endpoints    = ["https://registry.lab.reisman.org/v2/proxy.gcr.io"]
              overridePath = true
            }
            "ghcr.io" = {
              endpoints    = ["https://registry.lab.reisman.org/v2/proxy.ghcr.io"]
              overridePath = true
            }
            "quay.io" = {
              endpoints    = ["https://registry.lab.reisman.org/v2/proxy.quay.io"]
              overridePath = true
            }
            "registry.k8s.io" = {
              endpoints    = ["https://registry.lab.reisman.org/v2/proxy.registry.k8s.io"]
              overridePath = true
            }
          }
        }
      }
    })
  ]
}

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = local.config_patches
}

data "talos_machine_configuration" "worker" {
  cluster_name     = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = local.config_patches
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  count                       = length(local.controlplane_ips)
  node                        = local.controlplane_ips[count.index]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  count                       = length(local.worker_ips)
  node                        = local.worker_ips[count.index]
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.controlplane]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.controlplane_ips[0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.controlplane_ips[0]
}

data "talos_client_configuration" "this" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.controlplane_ips
  nodes                = concat(local.controlplane_ips, local.worker_ips)
}

resource "local_sensitive_file" "kubeconfig" {
  filename             = "${path.root}/kubeconfig"
  content              = talos_cluster_kubeconfig.this.kubeconfig_raw
  directory_permission = "0700"
  file_permission      = "0600"
}

resource "local_sensitive_file" "talosconfig" {
  filename             = "${path.root}/talosconfig"
  content              = data.talos_client_configuration.this.talos_config
  directory_permission = "0700"
  file_permission      = "0600"
}

data "talos_cluster_health" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes  = local.controlplane_ips
  worker_nodes         = local.worker_ips
  endpoints            = local.controlplane_ips
}
