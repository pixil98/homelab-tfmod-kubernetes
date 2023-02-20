locals {
  flux_yaml = <<-EOT
  ${templatefile("${path.module}/namespace.tftpl", { namespace = data.flux_sync.main.namespace })}
  ${templatefile("${path.module}/secret.tftpl", {
    name                = data.flux_sync.main.secret
    namespace           = data.flux_sync.main.namespace
    identity_base64     = base64encode(tls_private_key.main.private_key_pem)
    identity_pub_base64 = base64encode(tls_private_key.main.public_key_pem)
    knownhosts_base64   = base64encode(local.known_hosts)
  })}
  ${data.flux_install.main.content}
  ${data.flux_sync.main.content}
  EOT
}

output "yaml" {
  description = "Flux deployment yaml"
  value       = local.flux_yaml
}
