resource "proxmox_virtual_environment_vm" "talos_node" {
  name      = var.node_name
  tags      = ["k8s", "controller", var.node_namespace]
  pool_id   = var.node_namespace
  node_name = var.proxmox_node

  agent {
    enabled = true
  }
  stop_on_destroy = true

  cpu {
    type    = var.cpu_type
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    numa    = true
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.storage_pool
    import_from  = var.disk_image_id
    interface    = "scsi0"
    size         = var.disk_size_gb
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  on_boot = true

  initialization {
    datastore_id = var.storage_pool
    interface    = "ide2"

    ip_config {
      ipv4 {
        address = format("%s/%d", var.ip_address, var.subnet_mask)
        gateway = var.gateway
      }
    }
  }

  # Descriptive notes for Proxmox GUI (markdown format)
  description = <<-EOT
# Homelab ${title(var.node_namespace)} - ${title(var.node_role)} Node

## Cluster Information
- **Cluster**: ${var.node_namespace}
- **Node Role**: ${title(var.node_role)}
- **IP Address**: ${var.ip_address}

## Operating System
**Talos Linux** - Immutable Kubernetes OS
- 🔒 No SSH access (API-only management)
- 🔧 Use `talosctl` for node management
- ☸️ Use `kubectl` for Kubernetes operations

## Management
This VM is managed by Terraform. Do not modify directly in Proxmox.

### Access Commands
```bash
# Node health
talosctl -n ${var.ip_address} health

# Node logs
talosctl -n ${var.ip_address} dmesg

# Kubernetes status
kubectl get node ${var.node_name}
```
EOT
}
