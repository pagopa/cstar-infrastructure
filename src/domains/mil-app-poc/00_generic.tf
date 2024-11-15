data "azurerm_eventhub_namespace" "eventhub_mil" {
  name                = local.eventhub_mil_namespace_name
  resource_group_name = local.eventhub_mil_namespace_rg_name
}
