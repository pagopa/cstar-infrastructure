resource "azurerm_resource_group" "azdo_rg" {
  count    = var.enable_azdoa ? 1 : 0
  name     = "${local.project}-azdoa-rg"
  location = var.location

  tags = var.tags
}

module "azdoa_vmss_ubuntu_app" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent?ref=v6.14.1"
  count  = var.enable_azdoa ? 1 : 0

  name                = local.azuredevops_agent_vm_app_name
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_id           = module.azdoa_snet[0].id
  subscription_name   = data.azurerm_subscription.current.display_name
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  source_image_name   = var.azdoa_image_name

  tags = var.tags
}

module "azdoa_vmss_ubuntu_infra" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent?ref=v6.14.1"
  count  = var.enable_azdoa ? 1 : 0

  name                = local.azuredevops_agent_vm_infra_name
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_id           = module.azdoa_snet[0].id
  subscription_name   = data.azurerm_subscription.current.display_name
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  source_image_name   = var.azdoa_image_name

  tags = var.tags
}

module "azdoa_agent_vmss_ubuntu_perf" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//azure_devops_agent?ref=v7.2.0"
  count  = var.enable_azdoa_agent_performance ? 1 : 0

  name                = local.azuredevops_agent_vm_perf_name
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_id           = module.azdoa_snet[0].id
  subscription_name   = data.azurerm_subscription.current.display_name
  subscription_id     = data.azurerm_subscription.current.subscription_id
  location            = var.location
  source_image_name   = var.azdoa_image_name
  vm_sku              = var.azdoa_agent_performance_vm_sku

  tags = var.tags
}
