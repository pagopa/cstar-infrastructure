resource "kubernetes_service_account" "azure_devops" {
  metadata {
    name = "azure-devops"
  }
}

resource "kubernetes_cluster_role" "deployer" {
  metadata {
    name = "cluster-deployer"
  }

  rule {
    api_groups = [""]
    resources = ["deployments", "service"]
    verbs = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "deployer_binding" {
  metadata {
    name = "deployer-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = "default"
  }
}
