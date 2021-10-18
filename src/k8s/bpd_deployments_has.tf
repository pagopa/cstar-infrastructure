resource "kubernetes_horizontal_pod_autoscaler" "bpd_citizen_has" {
  count = var.env_short == "d" ? 1 : 0 # only in dev

  metadata {
    name      = "bpdcitizenhas" # has suffix stands for Horizontal AutoScaler
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  # standard metric is CPU utilization by pods
  spec {
    max_replicas = 10
    min_replicas = 1

    scale_target_ref {
      kind = "Deployment"
      # Deployment name and definition is reported in microservice repository
      name = "bpdmscitizen"
    }
  }
}