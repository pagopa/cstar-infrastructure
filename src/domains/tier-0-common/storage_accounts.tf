# ------------------------------------------------------------------------------
# Storage account containing configuration files for auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "auth" {
  name                          = replace("${local.project}-auth-st", "-", "")
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = var.tags
}