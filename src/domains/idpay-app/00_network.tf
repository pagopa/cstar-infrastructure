data "azurerm_resource_group" "apim_rg" {
  name = local.apim_rg_name
}

data "azurerm_api_management" "apim_core" {
  name                = local.apim_name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}
