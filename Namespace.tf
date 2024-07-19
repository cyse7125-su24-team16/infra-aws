resource "kubernetes_namespace" "example" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }

  depends_on = [module.eks.cluster_name]
}
