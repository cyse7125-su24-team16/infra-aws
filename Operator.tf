resource "kubernetes_namespace" "operator" {
  metadata {
    name = var.CRD_Namespace
    labels = {
      "istio-injection" = "enabled"
    }
  }

  depends_on = [module.eks.cluster_name]
}

resource "helm_release" "CRD_Creation" {
  name             = var.CRD_Name
  namespace        = var.CRD_Namespace
  create_namespace = true
  chart            = var.CRD_chart_path
  wait             = false
}
resource "helm_release" "CR_Creation" {
  name             = var.CR_Name
  namespace        = var.CRD_Namespace
  create_namespace = true
  chart            = var.CR_chart_path
  wait             = false
  depends_on       = [helm_release.CRD_Creation]
}
