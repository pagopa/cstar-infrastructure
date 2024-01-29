
module "kubernetes_service_account" {
  source    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_service_account?ref=v7.50.0"
  name      = "azure-devops"
  namespace = "kube-system"
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
  depends_on = [
    kubernetes_namespace.bpd,
    #kubernetes_namespace.fa,
    kubernetes_namespace.rtd
  ]

  for_each = toset(var.rbac_namespaces)

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


#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  depends_on   = [module.kubernetes_service_account]
  name         = "aks-azure-devops-sa-token"
  value        = module.kubernetes_service_account.sa_token
  content_type = "text/plain"

  key_vault_id = local.key_vault_id
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  depends_on   = [module.kubernetes_service_account]
  name         = "aks-azure-devops-sa-cacrt"
  value        = module.kubernetes_service_account.sa_ca_cert
  content_type = "text/plain"

  key_vault_id = local.key_vault_id
}
