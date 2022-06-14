resource "kubernetes_ingress_v1" "fa_ingress" {
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
            service {
              name = "famscustomer"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famscustomer/(.*)"
        }

        path {
          backend {
            service {
              name = "famstransaction"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famstransaction/(.*)"
        }

        path {
          backend {
            service {
              name = "famsenrollment"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famsenrollment/(.*)"
        }

        path {
          backend {
            service {
              name = "famspaymentinstrument"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famspaymentinstrument/(.*)"
        }

        path {
          backend {
            service {
              name = "famsmerchant"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famsmerchant/(.*)"
        }

        path {
          backend {
            service {
              name = "famsonboardingmerchant"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famsonboardingmerchant/(.*)"
        }

        path {
          backend {
            service {
              name = "famsinvoicemanager"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famsinvoicemanager/(.*)"
        }

        path {
          backend {
            service {
              name = "famsinvoiceprovider"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famsinvoiceprovider/(.*)"
        }

        path {
          backend {
            service {
              name = "famsnotificationmanager"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famsnotificationmanager/(.*)"
        }

        path {
          backend {
            service {
              name = "famstransactionerrormanager"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/famstransactionerrormanager/(.*)"
        }

        path {
          backend {
            service {
              name = "cstariobackendtest"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/cstariobackendtest/(.*)"
        }
      }
    }
  }
}
