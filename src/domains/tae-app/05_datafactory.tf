data "azurerm_data_factory" "datafactory" {
  name                = "${local.project}-df"
  resource_group_name = "${local.project}-df-rg"
}
