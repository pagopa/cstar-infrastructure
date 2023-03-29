resource "azurerm_resource_group" "azdo_rg" {
  count    = var.enable_azdoa ? 1 : 0
  name     = format("%s-azdoa-rg", local.project)
  location = var.location

  tags = var.tags
}

module "azdoa_li" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent?ref=v3.15.0"
  count               = var.enable_azdoa ? 1 : 0
  name                = format("%s-azdoa-vmss-li", local.project)
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_id           = module.azdoa_snet[0].id
  subscription        = data.azurerm_subscription.current.display_name

  tags = var.tags
}
