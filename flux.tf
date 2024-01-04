resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "flux" {
  title      = "flux - ${var.flux_github_branch}"
  repository = ${var.flux_github_repo_name}
  key        = tls_private_key.flux.public_key_openssh
  read_only  = true
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.flux]

  path = "${var.flux_github_target_path}"
}