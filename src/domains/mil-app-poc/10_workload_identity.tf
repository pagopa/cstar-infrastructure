module "workload_identity" {
  #   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity_configuration?ref=fix-workload-identity-info"
  source = "./.terraform/modules/__v3__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "${var.domain}-poc"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = var.domain

  key_vault_id                      = data.azurerm_key_vault.kv_domain.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get"]
  key_vault_secret_permissions      = ["Get"]
}

resource "azurerm_key_vault_access_policy" "access_auth_secret_kv" {
  key_vault_id = data.azurerm_key_vault.kv_auth.id

  tenant_id = data.azurerm_subscription.current.tenant_id
  object_id = module.workload_identity.user_assigned_identity_principal_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Restore", ]
  storage_permissions     = []
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Restore", "Purge", "Recover", ]
}