data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "${local.product}-cosmos-mongo-db-account"
  resource_group_name = "${local.product}-db-rg"
}