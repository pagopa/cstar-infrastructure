resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.domain
  }
}

resource "kubernetes_namespace" "namespace_system" {
  metadata {
    name = "${var.domain}-system"
  }
}
