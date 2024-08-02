resource "helm_release" "kube_prometheus_chart" {
  name             = var.prometheus_name
  namespace        = var.prometheus_namespace
  create_namespace = true
  repository       = var.prometheus_repository
  chart            = var.prometheus_chart
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  values           = [file("Kubernetes-Prometheus.yaml")]
}
