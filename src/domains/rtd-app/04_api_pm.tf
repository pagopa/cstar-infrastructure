## PagoPA APIM API Key named value ##
data "azurerm_key_vault_secret" "pagopa_platform_api_key" {
  count = var.enable.pm_integration ? 1 : 0

  name         = "pagopa-platform-apim-api-key-primary"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_api_management_named_value" "pagopa_platform_api_key" {
  count = var.enable.pm_integration ? 1 : 0

  name                = format("%s-pagopa-platform-api-key", var.env_short)
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  api_management_name = data.azurerm_api_management.apim_core.name

  display_name = "pagopa-platform-apim-api-key-primary"
  secret       = true

  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.pagopa_platform_api_key[count.index].id
  }
}
