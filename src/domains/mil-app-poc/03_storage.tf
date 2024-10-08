resource "azurerm_resource_group" "storage_rg" {
  name     = "cstar-${var.env_short}-${var.location_short}-${var.domain}-storage-rg"
  location = var.location

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Storage account containing configuration files.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "auth" {
  name                          = "${var.prefix}${var.env_short}${var.domain}authst"
  resource_group_name           = azurerm_resource_group.storage_rg.name
  location                      = azurerm_resource_group.storage_rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = var.tags
}

# ------------------------------------------------------------------------------
# Storage account.
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "conf" {
  name                          = "${var.prefix}${var.env_short}${var.domain}confst"
  resource_group_name           = azurerm_resource_group.storage_rg.name
  location                      = azurerm_resource_group.storage_rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  public_network_access_enabled = false
  tags                          = var.tags
}
