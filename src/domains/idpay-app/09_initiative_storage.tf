#
# Storage for Initiative Data (i.e. Logo)


#tfsec:ignore:azure-storage-default-action-deny
module "idpay_initiative_storage" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.15.2"

  name                            = replace("${var.domain}${var.env_short}-initiative-storage", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_enable_versioning
  resource_group_name             = azurerm_resource_group.rg_refund_storage.name
  location                        = var.location
  advanced_threat_protection      = var.storage_advanced_threat_protection
  allow_nested_items_to_be_public = true

  blob_delete_retention_days    = var.storage_delete_retention_days
  public_network_access_enabled = var.storage_public_network_access_enabled

  tags = var.tags
}

resource "azurerm_storage_container" "idpay_logo_container" {
  name                  = "logo"
  storage_account_name  = module.idpay_initiative_storage.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "idpay_ranking_container" {
  name                  = "ranking"
  storage_account_name  = module.idpay_initiative_storage.name
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "idpay_initiative_storage_private_endpoint" {

  name                = "${local.product}-initiative-storage-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_refund_storage.name
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_dns_zone_group {
    name                 = "${local.product}-initiative-storage-private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage_account.id]
  }

  private_service_connection {
    name                           = "${local.product}-initiative-storage-private-service-connection"
    private_connection_resource_id = module.idpay_initiative_storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  depends_on = [
    module.idpay_initiative_storage
  ]
}

# storage access key

resource "azurerm_key_vault_secret" "initiative_storage_access_key" {
  name         = "initiative-storage-access-key"
  value        = module.idpay_initiative_storage.primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "initiative_storage_connection_string" {
  name         = "initiative-storage-connection-string"
  value        = module.idpay_initiative_storage.primary_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "initiative_storage_blob_connection_string" {
  name         = "initiative-storage-blob-connection-string"
  value        = module.idpay_initiative_storage.primary_blob_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}
