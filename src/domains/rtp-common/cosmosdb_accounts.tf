# ------------------------------------------------------------------------------
# CosmosDB NoSQL account.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_account" "rtp" {
  name                          = "${local.project}-cosmos"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  kind                          = "GlobalDocumentDB"
  offer_type                    = "Standard"
  tags                          = var.tags
  public_network_access_enabled = false

  capabilities {
    name = "EnableUniqueCompoundNestedDocs"
  }

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

# ------------------------------------------------------------------------------
# Storing CosmosDB endpoint in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_rtp_endpoint" {
  name         = "cosmosdb-account-rtp-endpoint"
  value        = azurerm_cosmosdb_account.rtp.endpoint
  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tags         = var.tags
}