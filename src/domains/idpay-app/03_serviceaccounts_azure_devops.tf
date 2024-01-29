resource "kubernetes_namespace" "system_domain_namespace" {
  metadata {
    name = "${var.domain}-system"
  }
}


module "kubernetes_service_account" {
  source  = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_service_account?ref=5307e80"
  name = "azure-devops"
  namespace = local.system_domain_namespace
}

#-------------------------------------------------------------

resource "kubernetes_role_binding" "deployer_binding" {
  metadata {
    name      = "deployer-binding"
    namespace = local.domain_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = local.system_domain_namespace
  }
}

resource "kubernetes_role_binding" "system_deployer_binding" {
  metadata {
    name      = "system-deployer-binding"
    namespace = local.system_domain_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system-cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = local.system_domain_namespace
  }
}


#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  depends_on   = [module.kubernetes_service_account]
  name         = "${local.aks_name}-azure-devops-sa-token"
  value        = module.kubernetes_service_account.sa_token
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  depends_on   = [module.kubernetes_service_account]
  name         = "${local.aks_name}-azure-devops-sa-cacrt"
  value        = module.kubernetes_service_account.sa_ca_cert
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}


