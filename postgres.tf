resource "helm_release" "postgresql" {
  name       = var.postgresql_release_name
  namespace  = var.postgresql_namespace
  repository = var.bitnami_repository_url
  chart      = var.postgresql_chart_name
  version    = var.postgresql_chart_version

  values = [file("values.yaml")]

  depends_on = [
    module.eks,
  ]
}
