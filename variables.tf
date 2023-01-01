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

variable "vm_user_publickey" {
  description = "Virtual machine user public key"
  type        = string
  sensitive   = true
}

variable "vm_user_privatekey" {
  description = "Virtual machine user private key, only used to deploy kubernetes"
  type        = string
  sensitive   = true
}

#---------------------------------------------------------------------------------------------------
# Kubernetes
#---------------------------------------------------------------------------------------------------

variable "kubernetes_controller_count" {
  description = "The number of Kubernetes controllers to deploy"
  type        = number
  default     = 3
}

variable "kubernetes_controller_ips" {
  description = "IP addresses for controllers to use"
  type        = list(string)
}

variable "kubernetes_worker_count" {
  description = "The number of Kubernetes workers to deploy"
  type        = number
  default     = 5
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
