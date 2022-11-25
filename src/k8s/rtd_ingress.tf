resource "kubernetes_ingress_v1" "rtd_ingress" {
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
            service {
              name = "rtdmspaymentinstrumentmanager"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/rtdmspaymentinstrumentmanager/(.*)"
        }

        path {
          backend {
            service {
              name = "rtdmsfileregister"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/rtdmsfileregister/(.*)"
        }

        path {
          backend {
            service {
              name = "rtdmssenderauth"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/rtdmssenderauth/(.*)"
        }

        path {
          backend {
            service {
              name = "rtd-ms-enrolledpaymentinstrument"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/enrolledpaymentinstrumentmanager/(.*)"
        }

        path {
          backend {
            service {
              name = "rtd-ms-pieventprocessor"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/rtdmspieventprocessor/(.*)"
        }

        path {
          backend {
            service {
              name = "rtdmsfilereporter"
              port {
                number = var.default_service_port
              }
            }
          }
          path = "/rtdmsfilereporter/(.*)"
        }
      }
    }
  }
}
