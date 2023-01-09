#---------------------------------------------------------------------------------------------------
# Flux
#---------------------------------------------------------------------------------------------------
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
  default     = "homelab-deployments-flux"
}

variable "flux_github_branch" {
  description = "Github repository branch to use"
  type        = string
}

variable "flux_github_token" {
  description = "Github token for repository"
  type        = string
  sensitive   = true
}
