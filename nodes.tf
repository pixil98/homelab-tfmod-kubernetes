locals {
  talos_schematic = "dc7b152cb3ea99b821fcb7340ce7168313ce393d663740b791c36f6e95fc8586"
  talos_version   = element(data.talos_image_factory_versions.this.talos_versions, length(data.talos_image_factory_versions.this.talos_versions) - 1)

  controlplane_proxmox_nodes = [for i in range(length(var.kubernetes_controller_ips)) : var.nodes[i % length(var.nodes)]]
  worker_proxmox_nodes       = [for i in range(length(var.kubernetes_worker_ips)) : var.nodes[i % length(var.nodes)]]
}

data "talos_image_factory_versions" "this" {
  filters = {
    stable_versions_only = true
  }
}

resource "proxmox_virtual_environment_pool" "namespace_pool" {
  pool_id = format("k8s.%s", var.namespace)
}

resource "proxmox_download_file" "talos_nocloud_image" {
  for_each     = toset(var.nodes)
  content_type = "import"
  datastore_id = "local"
  node_name    = each.key

  file_name = "talos-${var.namespace}-${local.talos_version}-nocloud-amd64.qcow2"
  url       = "https://factory.talos.dev/image/${local.talos_schematic}/${local.talos_version}/nocloud-amd64.qcow2"
}

module "controlplanes" {
  source = "./modules/talos-node"

  count = length(var.kubernetes_controller_ips)

  node_name      = format("controlplane-%02d.%s.lab", count.index + 1, proxmox_virtual_environment_pool.namespace_pool.pool_id)
  node_role      = "controlplane"
  node_namespace = proxmox_virtual_environment_pool.namespace_pool.pool_id
  proxmox_node   = local.controlplane_proxmox_nodes[count.index]

  cpu_cores     = var.kubernetes_controller_cpu_cores
  cpu_sockets   = var.kubernetes_controller_cpu_sockets
  memory_mb     = var.kubernetes_controller_memory
  disk_image_id = proxmox_download_file.talos_nocloud_image[local.controlplane_proxmox_nodes[count.index]].id
  disk_size_gb  = var.kubernetes_controller_disk_size
  storage_pool  = var.vm_disk_class

  ip_address = var.kubernetes_controller_ips[count.index]
}

module "workers" {
  source = "./modules/talos-node"

  count = length(var.kubernetes_worker_ips)

  node_name      = format("worker-%02d.%s.lab", count.index + 1, proxmox_virtual_environment_pool.namespace_pool.pool_id)
  node_role      = "worker"
  node_namespace = proxmox_virtual_environment_pool.namespace_pool.pool_id
  proxmox_node   = local.worker_proxmox_nodes[count.index]

  cpu_cores     = var.kubernetes_worker_cpu_cores
  cpu_sockets   = var.kubernetes_worker_cpu_sockets
  memory_mb     = var.kubernetes_worker_memory
  disk_image_id = proxmox_download_file.talos_nocloud_image[local.worker_proxmox_nodes[count.index]].id
  disk_size_gb  = var.kubernetes_worker_disk_size
  storage_pool  = var.vm_disk_class

  ip_address = var.kubernetes_worker_ips[count.index]
}
