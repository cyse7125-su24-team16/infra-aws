resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.istio_namespace
  }
}

resource "helm_release" "istio_base_chart" {
  name             = var.isttio_base_name
  namespace        = var.istio_namespace
  create_namespace = true
  repository       = var.istio_repository
  chart            = var.istio_b_chart
  cleanup_on_fail  = true
  force_update     = false
  wait             = false
  set {
    name  = "defaultRevision"
    value = "default"
  }

  depends_on = [
    kubernetes_namespace.istio_system
  ]
}

resource "helm_release" "istiod_chart" {
  name             = var.istio_d_name
  namespace        = var.istio_namespace
  create_namespace = true
  repository       = var.istio_repository
  chart            = "istiod"
  cleanup_on_fail  = true
  force_update     = false
  wait             = true

  values = [
    file("Listio.yaml")
  ]

  depends_on = [
    helm_release.istio_base_chart
  ]
}

resource "helm_release" "istio_gateway_chart" {
  name             = var.istio_ingress_name
  namespace        = var.istio_namespace
  create_namespace = true
  repository       = var.istio_repository
  chart            = var.Istio_ingress_chart
  cleanup_on_fail  = true
  force_update     = false
  wait             = false

  values = [
    file("Listio.yaml")
  ]

  depends_on = [
    kubernetes_namespace.istio_system,
    helm_release.istiod_chart
  ]
}

# resource "null_resource" "istio_addons" {
#   provisioner "local-exec" {
#     command     = <<EOT
# for ADDON in kiali jaeger prometheus grafana
# do
#     ADDON_URL="https://raw.githubusercontent.com/istio/istio/release-1.20/samples/addons/$ADDON.yaml"
#     kubectl apply -f $ADDON_URL
# done
# EOT
#     interpreter = ["bash", "-c"]
#   }

#   depends_on = [
#     helm_release.istio_gateway_chart
#   ]
# }





