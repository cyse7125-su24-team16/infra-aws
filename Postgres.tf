resource "helm_release" "postgresql" {
  name       = var.postgresql_release_name
  namespace  = var.postgresql_namespace
  repository = var.bitnami_repository_url
  chart      = var.postgresql_chart_name
  version    = var.postgresql_chart_version

  values = [file(var.Postgresql_Yaml_File)]

  # set {
  #   name  = "storageClass"
  #   value = "ebs-sc"
  # }
  # set {
  #   name  = "persistence.enabled"
  #   value = "true"
  # }
  # set {
  #   name  = "persistence.size"
  #   value = "4Gi"
  # }

  depends_on = [
    module.eks,
    kubernetes_storage_class.ebs_sc,
  ]


}
