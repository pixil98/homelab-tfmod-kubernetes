resource "tls_private_key" "flux" {
  count  = var.flux_enabled ? 1 : 0
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "flux" {
  count  = var.flux_enabled ? 1 : 0
  title      = "flux - ${var.flux_github_branch}"
  repository = var.flux_github_repo_name
  key        = tls_private_key.flux[0].public_key_openssh
  read_only  = true
}

resource "flux_bootstrap_git" "flux" {
  count  = var.flux_enabled ? 1 : 0
  depends_on = [github_repository_deploy_key.flux[0]]

  path = var.flux_github_target_path
}

# Flux values configmap
data "jq_query" "flux_values" {
  count  = var.flux_enabled ? 1 : 0
  data = jsonencode(var.flux_values_json)
  query = "[paths(scalars|true) as $p | {([$p[]] | join(\".\")): getpath($p)}] | reduce .[] as $item ({}; . * $item)"
}

resource "kubernetes_config_map" "flux_values" {
  count  = var.flux_enabled ? 1 : 0
  metadata {
    name      = "flux-values"
    namespace = "flux-system"
  }

  data = jsondecode(data.jq_query.flux_values[0].result)
}
