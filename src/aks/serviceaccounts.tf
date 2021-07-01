resource "kubernetes_service_account" "azure_devops" {
  metadata {
    name      = "azure-devops"
    namespace = "kube-system"
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
    namespace = "kube-system"
  }
}

data "kubernetes_secret" "azure_devops_secret" {
  metadata {
    name      = kubernetes_service_account.azure_devops.default_secret_name
    namespace = "kube-system"
  }
}

resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  depends_on = [kubernetes_service_account.azure_devops]
  #tfsec:ignore:AZU023
  name         = "aks-azure-devops-sa-token"
  value        = data.kubernetes_secret.azure_devops_secret.data["token"]
  key_vault_id = local.key_vault_id
  content_type = "text/plain"
}

resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  depends_on = [kubernetes_service_account.azure_devops]
  #tfsec:ignore:AZU023
  name         = "aks-azure-devops-sa-cacrt"
  value        = data.kubernetes_secret.azure_devops_secret.data["ca.crt"]
  key_vault_id = local.key_vault_id
  content_type = "text/plain"
}
