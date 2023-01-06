# SSH
resource "tls_private_key" "main" {
  algorithm = "ECDSA"
  ecdsa_curve = "P256"
}

# Flux
data "flux_install" "main" {
  target_path = var.flux_github_target_path
  network_policy = false
}

data "flux_sync" "main" {
  target_path = var.flux_github_target_path
  url         = "ssh://git@github.com/${var.flux_github_repo_owner}/${var.flux_github_repo_name}.git"
  branch      = var.flux_github_branch
}

/*
# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
  }
}

# GitHub
data "github_repository" "main" {
  name = "${var.flux_github_repo_owner}/${var.flux_github_repo_name}"
}

resource "github_branch" "branch" {
  repository = data.github_repository.main.name
  branch     = var.flux_github_branch
}

resource "github_repository_deploy_key" "main" {
  title      = "flux - ${var.flux_github_branch}"
  repository = data.github_repository.main.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository          = data.github_repository.main.name
  file                = data.flux_install.main.path
  content             = data.flux_install.main.content
  branch              = github_branch.branch.branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.path
  content             = data.flux_sync.main.content
  branch              = github_branch.branch.branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.kustomize_path
  content             = data.flux_sync.main.kustomize_content
  branch              = github_branch.branch.branch
  overwrite_on_create = true
}
*/