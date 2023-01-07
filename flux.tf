module "flux" {
  source = "./modules/flux"
  count  = var.flux_enabled ? 1 : 0

  flux_github_target_path = var.flux_github_target_path
  flux_github_repo_owner  = var.flux_github_repo_owner
  flux_github_repo_name   = var.flux_github_repo_name
  flux_github_branch      = var.flux_github_branch
  flux_github_token       = var.flux_github_token
}
