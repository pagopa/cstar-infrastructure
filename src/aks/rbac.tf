data "azuread_group" "adgroup_externals" {
  display_name = format("%s-adgroup-externals", local.project)
}

data "azuread_group" "adgroup_contributors" {
  display_name = format("%s-adgroup-contributors", local.project)
}

data "azuread_group" "adgroup_security" {
  display_name = format("%s-adgroup-security", local.project)
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

  dynamic "rule" {
    for_each = var.env_short == "d" ? [""] : []

    content {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "list", "watch"]
    }
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
    name      = kubernetes_cluster_role.cluster_reader.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = data.azuread_group.adgroup_externals.object_id
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "edit_binding" {
  metadata {
    name = "edit-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "Group"
    name      = data.azuread_group.adgroup_contributors.object_id
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "view_binding" {
  metadata {
    name = "view-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    kind      = "Group"
    name      = data.azuread_group.adgroup_security.object_id
    namespace = "kube-system"
  }
}
