resource "kubernetes_ingress" "rtd_ingress" {
  depends_on = [helm_release.ingress]

  metadata {
    name      = "${kubernetes_namespace.rtd.metadata[0].name}-ingress"
    namespace = kubernetes_namespace.rtd.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"                = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
      "nginx.ingress.kubernetes.io/use-regex"      = "true"
    }
  }

  spec {
    rule {
      http {

        path {
          backend {
            service_name = "rtdmspaymentinstrumentmanager"
            service_port = var.default_service_port
          }
          path = "/rtdmspaymentinstrumentmanager/(.*)"
        }

      }
    }
  }
}
