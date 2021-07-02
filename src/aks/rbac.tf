data "azuread_group" "adgroup_externals" {
  display_name = format("%s-adgroup-externals", local.project)
}

resource "kubernetes_cluster_role" "cluster_reader" {
  metadata {
    name = "cluster-reader"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "pods/log", "services", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["deployments", "replicasets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "reader_binding" {
  metadata {
    name = "reader-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-reader"
  }

  subject {
    kind      = "Group"
    name      = data.azuread_group.adgroup_externals.object_id
    namespace = "kube-system"
  }
}
