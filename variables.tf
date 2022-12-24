#---------------------------------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------------------------------

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
  sensitive   = true
}

variable "vm_user_pubkey" {
  description = "Virtual machine user public key"
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

variable "kubernetes_worker_count" {
  description = "The number of Kubernetes workers to deploy"
  type        = number
  default     = 5
}