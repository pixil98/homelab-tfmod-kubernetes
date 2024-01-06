resource "kubernetes_secret" "sealed-secrets-key" {
  count  = var.sealed_secrets_key != null ? 1 : 0

  metadata {
    name      = "sealed-secrets-key"
    namespace = "kube-system"
    annotations = {
      "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
    }
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.key" = base64encode(var.sealed_secrets_key)
    "tls.crt" = base64encode(var.sealed_secrets_crt)
  }
}