resource "kubernetes_namespace" "example" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
    labels = merge(
      {
        "istio-injection" = "enabled"
      },
      each.value == "n2" ? { "name" = "n2" } : {}
    )
  }

  depends_on = [module.eks.cluster_name]
}
