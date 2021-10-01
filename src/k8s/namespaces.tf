resource "kubernetes_namespace" "monitoring" {
  count = var.env_short == "d" ? 1 : 0 # only in dev
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

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
