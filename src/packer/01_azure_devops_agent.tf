data "azurerm_resource_group" "resource_group" {
  name = "${local.project}-azdoa-rg"
}

module "azdoa_custom_image" {
  source              = "./.terraform/modules/__v3__/azure_devops_agent_custom_image"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = var.location
  image_name          = "${local.project}-azdo-agent-ubuntu2204-image"
  image_version       = var.azdo_agent_image_version
  subscription_id     = data.azurerm_subscription.current.subscription_id

  prefix = var.prefix
}
