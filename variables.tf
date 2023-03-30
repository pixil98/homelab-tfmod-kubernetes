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

#---------------------------------------------------------------------------------------------------
# Kubernetes
#---------------------------------------------------------------------------------------------------
variable "kubernetes_controller_ips" {
  description = "IP addresses for controllers to use"
  type        = list(string)
}

variable "kubernetes_worker_ips" {
  description = "IP addresses for workers to use"
  type        = list(string)
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
