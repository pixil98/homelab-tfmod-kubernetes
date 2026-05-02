locals {
  jq_flatten_with_prefix = "[paths(scalars|true) as $p | {([$p[]] | join(\"_\")): getpath($p)}] | reduce .[] as $item ({}; . * $item) | with_entries(.key |= \"%s_\" + .)"
}

resource "tls_private_key" "flux" {
  count       = var.flux_enabled ? 1 : 0
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "flux" {
  count      = var.flux_enabled ? 1 : 0
  title      = "flux - ${var.namespace}"
  repository = var.flux_github_repo_name
  key        = tls_private_key.flux[0].public_key_openssh
  read_only  = true
}

resource "flux_bootstrap_git" "flux" {
  count      = var.flux_enabled ? 1 : 0
  depends_on = [github_repository_deploy_key.flux[0], data.talos_cluster_health.this]

  path = var.flux_github_target_path
}

data "jq_query" "flux_core_values" {
  count = var.flux_enabled ? 1 : 0
  data  = var.flux_values_json
  query = format(local.jq_flatten_with_prefix, "vals")
}

resource "kubernetes_config_map_v1" "flux_core_values" {
  count = var.flux_enabled ? 1 : 0
  metadata {
    name      = "flux-values"
    namespace = flux_bootstrap_git.flux[0].namespace
  }

  data = jsondecode(data.jq_query.flux_core_values[0].result)
}

data "jq_query" "flux_core_secrets" {
  count = var.flux_enabled ? 1 : 0
  data  = var.flux_secrets_json
  query = format(local.jq_flatten_with_prefix, "secrets")
}

resource "kubernetes_secret_v1" "flux_core_secrets" {
  count = var.flux_enabled ? 1 : 0
  metadata {
    name      = "flux-secrets"
    namespace = flux_bootstrap_git.flux[0].namespace
  }

  data = jsondecode(data.jq_query.flux_core_secrets[0].result)
}

resource "kubectl_manifest" "flux_core_gitrepository" {
  count = (var.flux_enabled && var.flux_core_repository != null) ? 1 : 0
  yaml_body = templatefile(
    "${path.module}/flux_gitrepository.tftpl",
    {
      name      = "flux-core"
      namespace = flux_bootstrap_git.flux[0].namespace
      interval  = "1m"
      url       = var.flux_core_repository
      branch    = var.flux_core_branch
  })
}

resource "kubectl_manifest" "flux_core_kustomization" {
  count = (var.flux_enabled && var.flux_core_repository != null) ? 1 : 0
  yaml_body = templatefile(
    "${path.module}/flux_kustomization.tftpl",
    {
      name      = "flux-core"
      namespace = flux_bootstrap_git.flux[0].namespace
      interval  = "5m"
      source = {
        kind = "GitRepository"
        name = "flux-core"
      }
      path    = var.flux_core_path
      prune   = true
      timeout = "5m"
  })
}
