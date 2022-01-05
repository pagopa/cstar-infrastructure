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

        path {
          backend {
            service_name = "famsenrollment"
            service_port = var.default_service_port
          }
          path = "/famsenrollment/(.*)"
        }

        path {
          backend {
            service_name = "famspaymentinstrument"
            service_port = var.default_service_port
          }
          path = "/famspaymentinstrument/(.*)"
        }

        path {
          backend {
            service_name = "famsmerchant"
            service_port = var.default_service_port
          }
          path = "/famsmerchant/(.*)"
        }

        path {
          backend {
            service_name = "famsonboardingmerchant"
            service_port = var.default_service_port
          }
          path = "/famsonboardingmerchant/(.*)"
        }

        path {
          backend {
            service_name = "famsinvoicemanager"
            service_port = var.default_service_port
          }
          path = "/famsinvoicemanager/(.*)"
        }

        path {
          backend {
            service_name = "famsinvoiceprovider"
            service_port = var.default_service_port
          }
          path = "/famsinvoiceprovider/(.*)"
        }

        path {
          backend {
            service_name = "famsnotificationmanager"
            service_port = var.default_service_port
          }
          path = "/famsnotificationmanager/(.*)"
        }

        path {
          backend {
            service_name = "famstransactionerrormanager"
            service_port = var.default_service_port
          }
          path = "/famstransactionerrormanager/(.*)"
        }
      }
    }
  }
}
