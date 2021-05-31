resource "kubernetes_namespace" "bpd" {
  metadata {
    name = "bpd"
  }
}

resource "kubernetes_namespace" "fa" {
  metadata {
    name = "fa"
  }
}

resource "kubernetes_namespace" "rtd" {
  metadata {
    name = "rtd"
  }
}
