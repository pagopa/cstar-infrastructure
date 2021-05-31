resource "kubernetes_ingress" "bpd_ingress" {
  metadata {
    name = "${kubernetes_namespace.bpd.metadata[0].name}-ingress"
    namespace = kubernetes_namespace.bpd.metadata[0].name
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
            service_name = "bpdmscitizen"
            service_port = var.default_service_port
          }
          path = "/bpdmscitizen/(.*)"
        }

        path {
          backend {
            service_name = "bpdmscitizen-1"
            service_port = var.default_service_port
          }
          path = "/bpdmscitizen-1/(.*)"
        }

        path {
          backend {
            service_name = "bpdmspaymentinstrument"
            service_port = var.default_service_port
          }
          path = "/bpdmspaymentinstrument/(.*)"
        }

        path {
          backend {
            service_name = "bpdmsenrollment"
            service_port = var.default_service_port
          }
          path = "/bpdmsenrollment/(.*)"
        }

        path {
          backend {
            service_name = "bpdmswinningtransaction"
            service_port = var.default_service_port
          }
          path = "/bpdmswinningtransaction/(.*)"
        }

        path {
          backend {
            service_name = "bpdmsawardperiod"
            service_port = var.default_service_port
          }
          path = "/bpdmsawardperiod/(.*)"
        }

        path {
          backend {
            service_name = "cstariobackendtest"
            service_port = var.default_service_port
          }
          path = "/cstariobackendtest/(.*)"
        }

        path {
          backend {
            service_name = "bpdmstransactionerrormanager"
            service_port = var.default_service_port
          }
          path = "/bpdmstransactionerrormanager/(.*)"
        }

        path {
          backend {
            service_name = "bpdmsnotificationmanager"
            service_port = var.default_service_port
          }
          path = "/bpdmsnotificationmanager/(.*)"
        }

        path {
          backend {
            service_name = "bpdmsawardwinner"
            service_port = var.default_service_port
          }
          path = "/bpdmsawardwinner/(.*)"
        }

        path {
          backend {
            service_name = "bpdmsrankingprocessor"
            service_port = var.default_service_port
          }
          path = "/bpdmsrankingprocessor/(.*)"
        }

      }
    }
  }
}
