# ------------------------------------------------------------------------------
# CosmosDB account.
# ------------------------------------------------------------------------------
data "azurerm_cosmosdb_account" "mil" {
  name                = "${local.project}-cosmos"
  resource_group_name = azurerm_resource_group.data.name
}