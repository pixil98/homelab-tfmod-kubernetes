locals {
  talos_schematic = "ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515"
  talos_version   = element(data.talos_image_factory_versions.this.talos_versions, length(data.talos_image_factory_versions.this.talos_versions) - 1)
}

data "talos_image_factory_versions" "this" {
  filters = {
    stable_versions_only = true
  }
}

resource "proxmox_virtual_environment_pool" "namespace_pool" {
  pool_id = format("k8s.%s", var.namespace)
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  for_each = {
    for node in var.nodes : node => node
  }
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
  proxmox_node   = var.nodes[count.index % length(var.nodes)]

  cpu_cores     = var.kubernetes_controller_cpu_cores
  cpu_sockets   = var.kubernetes_controller_cpu_sockets
  memory_mb     = var.kubernetes_controller_memory
  disk_image_id = proxmox_virtual_environment_download_file.talos_nocloud_image[var.nodes[count.index % length(var.nodes)]].id
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
  proxmox_node   = var.nodes[count.index % length(var.nodes)]

  cpu_cores     = var.kubernetes_worker_cpu_cores
  cpu_sockets   = var.kubernetes_worker_cpu_sockets
  memory_mb     = var.kubernetes_worker_memory
  disk_image_id = proxmox_virtual_environment_download_file.talos_nocloud_image[var.nodes[count.index % length(var.nodes)]].id
  disk_size_gb  = var.kubernetes_worker_disk_size
  storage_pool  = var.vm_disk_class

  ip_address = var.kubernetes_worker_ips[count.index]
}
