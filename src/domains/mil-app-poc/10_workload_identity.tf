module "workload_identity" {
  #   source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_workload_identity_configuration?ref=fix-workload-identity-info"
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "${var.domain}-poc"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = var.domain

  key_vault_id                      = data.azurerm_key_vault.kv_domain.id
  key_vault_certificate_permissions = ["Get"]
  key_vault_key_permissions         = ["Get", "Create", "Encrypt", "Decrypt", "List"]
  key_vault_secret_permissions      = ["Get"]
}
