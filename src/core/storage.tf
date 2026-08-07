resource "azurerm_resource_group" "rg_storage" {
  name     = "${local.project}-storage-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "management_sa" {
  count = var.env_short == "p" ? 1 : 0

  name                     = replace("${local.project}-management-sa", "-", "")
  resource_group_name      = azurerm_resource_group.rg_storage.name
  location                 = var.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "RAGZRS"

  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}



resource "azurerm_private_endpoint" "managementstorage_private_endpoint" {
  count = var.env_short == "p" ? 1 : 0

  name                = "${local.project}-management-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_storage.name
  subnet_id           = module.private_endpoint_snet[0].id

  private_dns_zone_group {
    name                 = "${local.project}-managementstorage-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account.id]
  }

  private_service_connection {
    name                           = "${local.project}-managementstorage-private-service-connection"
    private_connection_resource_id = azurerm_storage_account.management_sa[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  depends_on = [
    azurerm_storage_account.management_sa
  ]
}


resource "azurerm_storage_container" "costs" {
  count                 = var.env_short == "p" ? 1 : 0
  name                  = "costs"
  storage_account_name  = azurerm_storage_account.management_sa[count.index].name
  container_access_type = "private"
}
