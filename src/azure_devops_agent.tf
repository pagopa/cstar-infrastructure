# TODO move into variables.tf
variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

variable "azdoa_scaleset_li_public_key" {
  type        = string
  description = "Azure DevOps agent public key."
}

# TODO move into network.tf
module "azdoa_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=main"
  count                                          = var.enable_azdoa ? 1 : 0
  name                                           = format("%s-azdoa-snet", local.project)
  address_prefixes                               = var.cidr_subnet_azdoa
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_resource_group" "azdo_rg" {
  count    = var.enable_azdoa ? 1 : 0
  name     = format("%s-azdoa-rg", local.project)
  location = var.location

  tags = var.tags
}

module "azdoa_li" {
  source              = "/Users/pasqualedevita/Documents/github/azurerm/azure_devops_agent"
  count               = var.enable_azdoa ? 1 : 0
  name                = format("%s-azdoa-vmss-li", local.project)
  resource_group_name = azurerm_resource_group.azdo_rg[0].name
  subnet_name         = module.azdoa_snet[0].name

  tags = var.tags
}

# module "azdoa_scaleset_li" {
#   source              = "/Users/pasqualedevita/Documents/github/azurerm/virtual_machine_scaleset_linux"
#   count               = var.enable_azdoa ? 1 : 0
#   name                = format("%s-azdoa-scale-set-linux", local.project)
#   location            = var.location
#   resource_group_name = azurerm_resource_group.azdo_rg[0].name
#   sku                 = "Standard_B1s"
#   instances           = 2
#   admin_username      = "pagopaadmin"
#   public_key          = var.azdoa_scaleset_li_public_key
#   subnet_id           = module.azdoa_snet[0].id

#   tags = var.tags
# }
