resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_namespace" "bpd" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name = "bpd"
  }
}

resource "kubernetes_namespace" "fa" {

  count = var.enable.fa.api ? 1 : 0

  metadata {
    name = "fa"
  }
}

resource "kubernetes_namespace" "rtd" {
  metadata {
    name = "rtd"
  }
}
