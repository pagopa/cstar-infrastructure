data "azurerm_cosmosdb_account" "cosmos" {
  name                = "${local.project}-cosmos"
  resource_group_name = "${local.project}-data-rg"
}