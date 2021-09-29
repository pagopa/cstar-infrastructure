resource "kubernetes_ingress" "fa_ingress" {
  depends_on = [helm_release.ingress]

  metadata {
    name      = "${kubernetes_namespace.fa.metadata[0].name}-ingress"
    namespace = kubernetes_namespace.fa.metadata[0].name
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
            service_name = "famscustomer"
            service_port = var.default_service_port
          }
          path = "/famscustomer/(.*)"
        }

        path {
          backend {
            service_name = "famstransaction"
            service_port = var.default_service_port
          }
          path = "/famstransaction/(.*)"
        }
      }
    }
  }
}
