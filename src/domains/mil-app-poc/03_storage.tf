resource "azurerm_resource_group" "storage_rg" {
  name     = "${local.product}-${var.domain}-storage-rg"
  location = var.location

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Storage account containing configuration files.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "auth" {
  name                          = "${var.prefix}${var.env_short}authst"
  resource_group_name           = azurerm_resource_group.storage_rg.name
  location                      = azurerm_resource_group.storage_rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = var.tags
}
