#---------------------------------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------------------------------
variable "nodes" {
  description = "Array of nodes to host the cluster"
  type        = list(string)
}

variable "namespace" {
  description = "Namespace to which the cluster belongs"
  type        = string
}

#---------------------------------------------------------------------------------------------------
# Proxmox
#---------------------------------------------------------------------------------------------------

variable "proxmox_endpoint" {
  description = "Proxmox endpoint"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox username"
  type        = string
  sensitive   = true
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

#---------------------------------------------------------------------------------------------------
# Virtual Machines
#---------------------------------------------------------------------------------------------------
variable "vm_user" {
  description = "Virtual machine username"
  type        = string
}

variable "vm_user_privatekey" {
  description = "Virtual machine user private key, only used to deploy kubernetes"
  type        = string
  sensitive   = true
}

variable "vm_disk_class" {
  description = "Virtual machine disk classification"
  type        = string
}

#---------------------------------------------------------------------------------------------------
# Kubernetes
#---------------------------------------------------------------------------------------------------
variable "kubernetes_controller_ips" {
  description = "IP addresses for controllers to use"
  type        = list(string)
}

variable "kubernetes_controller_cpu_cores" {
  description = "Number of cpu cores to allocate per controller"
  type        = number
  default     = 1
}

variable "kubernetes_controller_cpu_sockets" {
  description = "Number of cpu sockets to allocate per controller"
  type        = number
  default     = 1
}

variable "kubernetes_controller_memory" {
  description = "Amount of memory in megabytes to allocate per controller"
  type        = number
  default     = 4096
}

variable "kubernetes_controller_disk_size" {
  description = "Size of disk in gigabytes to allocate per controller"
  type        = string
  default     = 10
}

variable "kubernetes_worker_ips" {
  description = "IP addresses for workers to use"
  type        = list(string)
}

variable "kubernetes_worker_cpu_cores" {
  description = "Number of cpu cores to allocate per worker"
  type        = number
  default     = 4
}

variable "kubernetes_worker_cpu_sockets" {
  description = "Number of cpu sockets to allocate per worker"
  type        = number
  default     = 2
}

variable "kubernetes_worker_memory" {
  description = "Amount of memory in megabytes to allocate per worker"
  type        = number
  default     = 16384
}

variable "kubernetes_worker_disk_size" {
  description = "Size of disk in gigabytes to allocate per worker"
  type        = number
  default     = 30
}

#---------------------------------------------------------------------------------------------------
# Puppet
#---------------------------------------------------------------------------------------------------
variable "puppet_git_repo" {
  description = "Git repository for fetching Puppet roles. Only supports https."
  type        = string
  default     = "https://github.com/pixil98/homelab-puppet.git"
}

variable "puppet_git_ref" {
  description = "Git ref"
  type        = string
  default     = "production"
}

#---------------------------------------------------------------------------------------------------
# Flux
#---------------------------------------------------------------------------------------------------
variable "flux_enabled" {
  description = "Whether or not flux should be configured"
  type        = bool
  default     = false
}

variable "flux_github_target_path" {
  description = "Path in Github repo to store Flux files"
  type        = string
  default     = "flux"
}

variable "flux_github_repo_owner" {
  description = "Github account that owns the repository"
  type        = string
  default     = "pixil98"
}

variable "flux_github_repo_name" {
  description = "Github repository name"
  type        = string
  default     = "homelab-deployments"
}

variable "flux_github_branch" {
  description = "Github repository branch to use"
  type        = string
  default     = null
}

variable "flux_github_token" {
  description = "Github token for repository"
  type        = string
  sensitive   = true
  default     = null
}

variable "flux_values_json" {
  description = "An object where the path to each value will be mapped to the key of a config map and loaded into the cluster"
  type        = map
  default     = null
}

variable "flux_core_repository_name" {
  description = "Core flux repository repository"
  type        = string
  default     = null  
}

variable "flux_core_repository_branch" {
  description = "Core repository branch"
  type        = string
  default     = "main"
}

#---------------------------------------------------------------------------------------------------
# Sealed Secrets
#---------------------------------------------------------------------------------------------------
variable "sealed_secrets_key" {
  description = "Sealed secrets tls key"
  type        = string
  sensitive   = true
  default     = null
}

variable "sealed_secrets_crt" {
  description = "Sealed Secrets tls public certificate"
  type        = string
  sensitive   = true
  default     = null
}
