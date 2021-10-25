resource "kubernetes_horizontal_pod_autoscaler" "hpa" {

  for_each = var.autoscaling_specs

  metadata {
    name      = format("hpa-%s", each.key)
    namespace = each.value.namespace
  }

  spec {
    max_replicas = each.value.max_replicas
    min_replicas = each.value.min_replicas

    scale_target_ref {
      kind = "Deployment"
      name = each.key
      api_version = "apps/v1"
    }

    # Metric bloc uses api object autoscaling/v2beta2
    dynamic "metric" {
      for_each = each.value.metrics
      content {
        type = metric.value.type
   
        resource {
          name = metric.value.resource.name
          target {
            type  = metric.value.resource.target.type
            average_utilization = metric.value.resource.target.average_utilization
         }
        }
      }
      
    }
  }
}