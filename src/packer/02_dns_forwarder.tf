module "dns_forwarder_image" {
  source              = "./.terraform/modules/__v3__/dns_forwarder_vm_image"
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
  location            = var.location
  image_name          = "${local.project}-dns-forwarder-ubuntu2204-image"
  image_version       = var.dns_forwarder_image_version
  subscription_id     = data.azurerm_subscription.current.subscription_id
  prefix              = local.project

}
