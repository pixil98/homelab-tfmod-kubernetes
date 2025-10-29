# Talos Node Module Variables
# Configuration for creating Talos Linux Kubernetes nodes

# Basic Node Configuration
variable "node_name" {
  description = "Base name for the Talos node"
  type        = string
}

variable "node_role" {
  description = "Role of the node: controlplane or worker"
  type        = string

  validation {
    condition     = contains(["controlplane", "worker"], var.node_role)
    error_message = "Node role must be either 'controlplane' or 'worker'."
  }
}

variable "node_namespace" {
  description = "Namespace for the Talos node"
  type        = string
}

variable "proxmox_node" {
  description = "Proxmox node name where the VM will be created"
  type        = string
}

# Hardware Configuration
variable "cpu_cores" {
  description = "Number of CPU cores for the node"
  type        = number
  default     = 2

  validation {
    condition     = var.cpu_cores >= 2 && var.cpu_cores <= 32
    error_message = "CPU cores must be between 2 and 32 for Kubernetes nodes."
  }
}

variable "cpu_sockets" {
  description = "Number of CPU sockets for the node"
  type        = number
  default     = 1

  validation {
    condition     = var.cpu_sockets >= 1 && var.cpu_sockets <= 8
    error_message = "CPU sockets must be between 1 and 8 for Kubernetes nodes."
  }
}

variable "memory_mb" {
  description = "Memory allocation for the node in MB"
  type        = number
  default     = 4096

  validation {
    condition     = var.memory_mb >= 2048
    error_message = "Kubernetes nodes require at least 2048MB of memory."
  }
}

variable "disk_image_id" {
  description = "ID of the disk image to use for the node"
  type        = string
}

variable "disk_size_gb" {
  description = "Disk size for the node in GB"
  type        = number
  default     = 40

  validation {
    condition     = var.disk_size_gb >= 20
    error_message = "Kubernetes nodes require at least 20GB disk space."
  }
}

variable "cpu_type" {
  description = "CPU type for the node"
  type        = string
  default     = "x86-64-v2-AES"
}

# Storage Configuration
variable "storage_pool" {
  description = "Storage pool for VM disks"
  type        = string
}

# Network Configuration
variable "ip_address" {
  description = "Static IP address for the node"
  type        = string
}

variable "subnet_mask" {
  description = "Subnet mask in CIDR notation (e.g., 24)"
  type        = number
  default     = 20
}

variable "gateway" {
  description = "Network gateway for the node"
  type        = string
  default     = "192.168.0.1"
}
