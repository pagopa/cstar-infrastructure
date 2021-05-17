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

  tags = var.tags
}