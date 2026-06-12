output "ip_address" {
  description = "Primary IP address of the node"
  value       = var.ip_address

  depends_on = [proxmox_virtual_environment_vm.talos_node]
}
