config {
  format = "default"
  plugin_dir = "~/.tflint.d/plugins"

  module = true
  force = false
  disabled_by_default = false
}

# Disabling this for now since the modules are still under active development
rule "terraform_module_pinned_source" {
  enabled = false
}