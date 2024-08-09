resource "helm_release" "metrics_server" {
  name       = var.Metrics_server_chart_name
  namespace  = var.Autoscaler_namespace
  repository = var.bitnami_repository_url
  chart      = var.Metrics_Chart_Name
  version    = var.Metrics_server_chart_version

  values = [file(var.Metrics_Yaml_File)]

  depends_on = [
    module.eks,

  ]
}
