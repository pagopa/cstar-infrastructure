# ------------------------------------------------------------------------------
# Storage account containing configuration files for payment-notice and
# fee-calculator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "conf" {
  name                          = replace("${local.project}-conf-st", "-", "")
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = local.tags
}