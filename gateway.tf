locals {
  gateway_backend_port                = 443
  gateway_cert_manager_kustomization  = "flux-core-routing-cert-manager-config"
  gateway_class_name                  = "infrastructure-routing"
  gateway_cluster_issuer_name         = "letsencrypt-production-cloudflare"
  gateway_envoy_config_kustomization  = "infrastructure-envoy-config"
  gateway_flux_config_name            = "flux-values"
  gateway_flux_secret_name            = "flux-secrets"
  gateway_flux_source_name            = "flux-system"
  gateway_listener_http_apex          = "http-apex"
  gateway_listener_http_wildcard      = "http-wildcard"
  gateway_listener_https_apex         = "https-apex"
  gateway_listener_https_wildcard     = "https-wildcard"
  gateway_load_balancer_ip_variable   = "$${vals_infra_envoyGateway_loadBalancerIP}"
  gateway_private_key_rotation_policy = "Always"
  gateway_route_manifest_name         = "routing.yaml"
  gateway_routing_namespace           = "infrastructure-routing"
  gateway_system_ca_name              = "System"
  gateway_tls_mode                    = "Terminate"

  gateway_flux_values = jsondecode(var.flux_values_json)
  gateway_domain      = try(trimspace(local.gateway_flux_values.info.cluster.domain), "")
  gateway_backend_ip  = try(trimspace(local.gateway_flux_values.infra.ingress.ipAddress), "")
  gateway_name        = var.namespace
  gateway_tls_secret  = "${var.namespace}-tls"

  gateway_route_kustomization = templatefile(
    "${path.module}/gateway_route_kustomization.tftpl",
    {
      route_manifest_name = local.gateway_route_manifest_name
    },
  )

  gateway_route_content = templatefile(
    "${path.module}/gateway_route.tftpl",
    {
      backend_ip                  = local.gateway_backend_ip
      backend_port                = local.gateway_backend_port
      domain                      = local.gateway_domain
      gateway_class_name          = local.gateway_class_name
      gateway_name                = local.gateway_name
      issuer_name                 = local.gateway_cluster_issuer_name
      listener_http_apex          = local.gateway_listener_http_apex
      listener_http_wildcard      = local.gateway_listener_http_wildcard
      listener_https_apex         = local.gateway_listener_https_apex
      listener_https_wildcard     = local.gateway_listener_https_wildcard
      load_balancer_ip_variable   = local.gateway_load_balancer_ip_variable
      private_key_rotation_policy = local.gateway_private_key_rotation_policy
      routing_namespace           = local.gateway_routing_namespace
      system_ca_name              = local.gateway_system_ca_name
      tls_mode                    = local.gateway_tls_mode
      tls_secret                  = local.gateway_tls_secret
    },
  )

  gateway_flux_registration = templatefile(
    "${path.module}/gateway_flux_registration.tftpl",
    {
      cert_manager_kustomization = local.gateway_cert_manager_kustomization
      envoy_kustomization        = local.gateway_envoy_config_kustomization
      flux_config_name           = local.gateway_flux_config_name
      flux_secret_name           = local.gateway_flux_secret_name
      flux_source_name           = local.gateway_flux_source_name
      gateway_name               = local.gateway_name
    },
  )

  gateway_commit_message = "Manage ${var.namespace} infrastructure gateway registration"
}

resource "github_repository_file" "gateway_route_kustomization" {
  count = var.infrastructure_gateway_registration_enabled ? 1 : 0

  repository          = var.flux_github_repo_name
  branch              = var.infrastructure_gateway_repository_branch
  file                = "routes/${local.gateway_name}/kustomization.yaml"
  content             = local.gateway_route_kustomization
  commit_message      = local.gateway_commit_message
  overwrite_on_create = false

  lifecycle {
    precondition {
      condition     = try(length(trimspace(var.flux_github_token)) > 0, false)
      error_message = "flux_github_token must be set when infrastructure gateway registration is enabled."
    }

    precondition {
      condition = length(local.gateway_domain) <= 253 && length(split(".", local.gateway_domain)) >= 2 && alltrue([
        for label in split(".", local.gateway_domain) :
        length(label) <= 63 && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", label))
      ])
      error_message = "flux_values_json must define info.cluster.domain as a valid DNS name when infrastructure gateway registration is enabled."
    }

    precondition {
      condition     = can(cidrhost("${local.gateway_backend_ip}/32", 0)) || can(cidrhost("${local.gateway_backend_ip}/128", 0))
      error_message = "flux_values_json must define infra.ingress.ipAddress as an IP address when infrastructure gateway registration is enabled."
    }

    precondition {
      condition     = length(local.gateway_name) <= 49 && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", local.gateway_name))
      error_message = "namespace must be a valid Kubernetes name of at most 49 characters when infrastructure gateway registration is enabled."
    }
  }
}

resource "github_repository_file" "gateway_route" {
  count = var.infrastructure_gateway_registration_enabled ? 1 : 0

  repository          = var.flux_github_repo_name
  branch              = var.infrastructure_gateway_repository_branch
  file                = "routes/${local.gateway_name}/routing.yaml"
  content             = local.gateway_route_content
  commit_message      = local.gateway_commit_message
  overwrite_on_create = false

  depends_on = [github_repository_file.gateway_route_kustomization]
}

resource "github_repository_file" "gateway_flux_registration" {
  count = var.infrastructure_gateway_registration_enabled ? 1 : 0

  repository          = var.flux_github_repo_name
  branch              = var.infrastructure_gateway_repository_branch
  file                = "flux/registrations/${local.gateway_name}.yaml"
  content             = local.gateway_flux_registration
  commit_message      = local.gateway_commit_message
  overwrite_on_create = false

  depends_on = [github_repository_file.gateway_route]
}
