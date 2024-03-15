# APIM subnet
module "apim_v2_temp_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v7.69.1"
  name                 = "${local.project}-apimv2-temp-snet"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet_integration.name
  address_prefixes     = var.cidr_subnet_apim_temp

  service_endpoints = ["Microsoft.Web"]
}

resource "azurerm_public_ip" "apimv2_public_ip_deleteme" {
  name                = "${local.project}-apim-pip-deleteme"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  location            = var.location
  sku                 = "Standard"
  domain_name_label   = "apim-${var.env_short}-cstar-deleteme"
  allocation_method   = "Static"

  zones = var.apim_v2_zones

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "apim_stv2_temp_snet_link_nsg" {
  subnet_id                 = module.apim_v2_temp_snet.id
  network_security_group_id = azurerm_network_security_group.apim_v2_snet_nsg.id
}
