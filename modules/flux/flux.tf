data "flux_install" "main" {
  target_path    = var.flux_github_target_path
  network_policy = false
}

data "flux_sync" "main" {
  target_path = var.flux_github_target_path
  url         = "ssh://git@github.com/${var.flux_github_repo_owner}/${var.flux_github_repo_name}.git"
  branch      = var.flux_github_branch
}
