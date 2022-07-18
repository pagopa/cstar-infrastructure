data "azurerm_data_factory" "datafactory" {
  name                = format("%s-df", local.project)
  resource_group_name = format("%s-df-rg", local.project)
}