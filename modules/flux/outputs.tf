locals {
  flux_yaml = <<-EOT
  ${templatefile("${path.module}/namespace.tftpl", { namespace = "flux-system" })}
  ${data.flux_install.main.content}
  ${data.flux_sync.main.content}
  EOT
}

output "yaml" {
  description = "Flux deployment yaml"
  value       = local.flux_yaml
}
