resource "kubernetes_service_account" "azure_devops" {
  metadata {
    name      = "azure-devops"
    namespace = "default"
  }
  automount_service_account_token = false
}

resource "kubernetes_cluster_role" "cluster_deployer" {
  metadata {
    name = "cluster-deployer"
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding" "deployer_binding" {
  for_each = toset(["bpd", "rtd", "fa"])

  metadata {
    name      = "deployer-binding"
    namespace = each.key
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

data "kubernetes_secret" "azure_devops_secret" {
  metadata {
    name = kubernetes_service_account.azure_devops.default_secret_name
  }
}
