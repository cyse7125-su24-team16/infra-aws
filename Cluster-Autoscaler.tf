resource "helm_release" "Cluster_Autoscaler" {
  name             = var.Cluster_Autoscaler_name
  namespace        = var.Autoscaler_namespace
  create_namespace = true
  repository       = var.Autoscaler_chart_name
  chart            = var.chart_path
  wait             = false
  values           = [file(var.Autoscaler_values_file)]
}

