resource "azurerm_resource_group" "workbook_rg" {
  count = contains(["u", "p"], var.env_short) ? 1 : 0

  name     = "${local.project}-workbook-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_application_insights_workbook" "workbook" {
  count = contains(["u", "p"], var.env_short) ? 1 : 0

  name                = uuid()
  resource_group_name = azurerm_resource_group.workbook_rg[0].name
  location            = azurerm_resource_group.workbook_rg[0].location
  display_name        = "EMD Dashboard ${upper(var.env)} v2"
  data_json = templatefile("${path.module}/workbooks/EMDDashboard${upper(var.env)}v2.json.tpl",
    {
      subscription_id = data.azurerm_subscription.current.subscription_id
      prefix          = var.prefix
      env_short       = var.env_short
  })

  tags = var.tags
}
