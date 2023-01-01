config {
  module = false
  force = false
}

# Disabling this for now since the modules are still under active development
rule "terraform_module_pinned_source" {
  enabled = false
}