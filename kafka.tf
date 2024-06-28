resource "helm_release" "kafka" {
  name       = var.kafka_release_name
  repository = var.bitnami_repository_url
  chart      = var.kafka_chart_name
  version    = var.kafka_chart_version
  namespace  = var.kafka_namespace

  values = [file(var.values_file)]

  depends_on = [module.eks.cluster_name, kubernetes_namespace.example["n2"]]
}


