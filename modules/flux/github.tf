locals {
  known_hosts = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}

resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

data "github_repository" "main" {
  full_name = "${var.flux_github_repo_owner}/${var.flux_github_repo_name}"
}

data "github_branch" "branch" {
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
  branch              = data.github_branch.branch.branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.path
  content             = data.flux_sync.main.content
  branch              = data.github_branch.branch.branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.kustomize_path
  content             = data.flux_sync.main.kustomize_content
  branch              = data.github_branch.branch.branch
  overwrite_on_create = true
}
