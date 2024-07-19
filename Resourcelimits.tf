resource "kubernetes_resource_quota" "example" {
  for_each = toset(var.namespaces)

  metadata {
    name      = var.Resource_Quota_Name
    namespace = each.value
  }

  spec {
    hard = {
      cpu    = var.resource_quota_cpu[each.value]
      memory = var.resource_quota_memory[each.value]
    }
  }

  depends_on = [kubernetes_namespace.example]
}

resource "kubernetes_limit_range" "example" {
  for_each = toset(var.namespaces)

  metadata {
    name      = var.Limit_Range_Name
    namespace = each.value
  }

  spec {
    limit {
      type = "Container"
      default = {
        cpu    = var.limit_range_default_cpu[each.value]
        memory = var.limit_range_default_memory[each.value]
      }
      default_request = {
        cpu    = var.limit_range_default_request_cpu[each.value]
        memory = var.limit_range_default_request_memory[each.value]
      }
    }
  }

  depends_on = [kubernetes_namespace.example]
}
