resource "kubernetes_namespace" "op" {
  metadata {
    name = var.CRD_Namespace
    # labels = {
    #   istio-injection = "enabled"
    # }
  }
}

resource "helm_release" "CRD_Creation" {
  name             = var.CRD_Name
  namespace        = var.CRD_Namespace
  create_namespace = false # Use existing namespace
  chart            = var.CRD_chart_path
  wait             = false
  depends_on       = [kubernetes_namespace.op]
}

resource "helm_release" "CR_Creation" {
  name             = var.CR_Name
  namespace        = var.CRD_Namespace
  create_namespace = false # Use existing namespace
  chart            = var.CR_chart_path
  wait             = false
  depends_on       = [helm_release.CRD_Creation]
}
