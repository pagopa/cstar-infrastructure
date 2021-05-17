resource "azurerm_resource_group" "sec_rg" {
  name     = format("%s-sev-rg", local.project)
  location = var.location

  tags = var.tags
}


module "key_vault" {
  source              = "git::https://github.com/pagopa/azurerm.git//key_vault?ref=main"
  name                = format("%s-kv", local.project)
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  terraform_cloud_object_id = data.azurerm_client_config.current.client_id

  tags = var.tags
}

/* TODO
## api management policy ## 
resource "azurerm_key_vault_access_policy" "api_management_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.apim.principal_id

  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []
}
*/

/*
## user assined identity: (application gateway) ##
resource "azurerm_key_vault_access_policy" "app_gateway_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id

  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.main.principal_id
  key_permissions         = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []
}
*/

## ad group policy ##
resource "azurerm_key_vault_access_policy" "ad_group_policy" {
  count        = var.ad_key_vault_group_object_id != null ? 1 : 0
  key_vault_id = module.key_vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.ad_key_vault_group_object_id

  key_permissions     = ["Get", "List", "Update", "Create", "Import", "Delete", ]
  secret_permissions  = ["Get", "List", "Set", "Delete", ]
  storage_permissions = []
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import",
    "Delete", "Restore", "Purge", "Recover"
  ]
}

/*
## azure devops ##
resource "azurerm_key_vault_access_policy" "cert_renew_policy" {
  count        = var.cert_renew_app_object_id == null ? 0 : 1
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.cert_renew_app_object_id

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Import",
  ]
}
*/