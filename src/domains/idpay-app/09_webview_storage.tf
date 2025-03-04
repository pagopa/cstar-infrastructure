#tfsec:ignore:azure-storage-default-action-deny
module "idpay_webview_storage" {
  source = "./.terraform/modules/__v3__/storage_account"

  name                            = replace("${var.domain}${var.env_short}-webview-storage", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_enable_versioning
  resource_group_name             = azurerm_resource_group.rg_refund_storage.name
  location                        = var.location
  advanced_threat_protection      = var.storage_advanced_threat_protection
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = var.storage_public_network_access_enabled

  blob_delete_retention_days = var.storage_delete_retention_days

  tags = var.tags
}

resource "azurerm_private_endpoint" "idpay_webview_storage_private_endpoint" {

  name                = "${local.product}-webview-storage-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_refund_storage.name
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_dns_zone_group {
    name                 = "${local.product}-webview-storage-private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage_account.id]
  }

  private_service_connection {
    name                           = "${local.product}-webview-storage-private-service-connection"
    private_connection_resource_id = module.idpay_webview_storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  depends_on = [
    module.idpay_webview_storage
  ]
}


resource "azurerm_storage_container" "idpay_webview_container" {
  name                  = "webview"
  storage_account_name  = module.idpay_webview_storage.name
  container_access_type = "private"
}

resource "azurerm_key_vault_secret" "webview_storage_access_key" {
  name         = "webview-storage-access-key"
  value        = module.idpay_webview_storage.primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "webview_storage_connection_string" {
  name         = "webview-storage-connection-string"
  value        = module.idpay_webview_storage.primary_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_role_assignment" "webview_storage_data_contributor" {
  scope                = module.idpay_webview_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_api_management.apim_core.identity[0].principal_id

  depends_on = [
    module.idpay_webview_storage
  ]
}
