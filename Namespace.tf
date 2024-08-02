resource "kubernetes_namespace" "example" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value

    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.eks.cluster_name]
}
