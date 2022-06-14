resource "kubernetes_ingress_v1" "bpd_ingress" {
  depends_on = [helm_release.ingress]

  metadata {
    name      = "${kubernetes_namespace.bpd.metadata[0].name}-ingress"
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
            service {
              name = "bpdmscitizen"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmscitizen/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmscitizen-1"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmscitizen-1/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmspaymentinstrument"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmspaymentinstrument/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmsenrollment"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmsenrollment/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmswinningtransaction"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmswinningtransaction/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmsawardperiod"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmsawardperiod/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmstransactionerrormanager"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmstransactionerrormanager/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmsnotificationmanager"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmsnotificationmanager/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmsawardwinner"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmsawardwinner/(.*)"
        }

        path {
          backend {
            service {
              name = "bpdmsrankingprocessor"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/bpdmsrankingprocessor/(.*)"
        }

      }
    }
  }
}
