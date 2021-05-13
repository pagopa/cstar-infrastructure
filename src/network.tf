resource "azurerm_resource_group" "rg_vnet" {
  name     = format("%s-vnet-rg", local.project)
  location = var.location

  tags = var.tags
}

module "vnet" {
  source              = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=main"
  name                = format("%s-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_vnet

  tags = var.tags

}

## Database subnet
module "db_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=main"
  name                                           = format("%s-db-snet", local.project)
  address_prefixes                               = var.cidr_subnet_db
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  service_endpoints                              = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}


resource "azurerm_private_dns_zone" "private_dns_zone_postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  name                  = format("%s-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_postgres.name
  virtual_network_id    = module.vnet.id

  tags = var.tags
}


# k8s cluster subnet 
module "k8s_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=main"
  name                 = format("%s-k8s-snet", local.project)
  address_prefixes     = var.cidr_subnet_k8s
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name

  delegation = {
    name = "default"

    service_delegation = {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]

}


/*

# Subnet to host the application gateway
module "public-snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=main"
  name                 = format("%s-public-snet", local.project)
  address_prefixes     = var.cidr_subnet_public
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  tags = var.tags
}

# Application gateway public ip
resource "azurerm_public_ip" "apigateway_public_ip" {
  name                = format("%s-apigateway-pip", local.project)
  resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  location            = azurerm_virtual_network.vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}

# APIM subnet
module "apim_snet" {
  name                 = format("%s-apim-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.cidr_subnet_apim

  service_endpoints = ["Microsoft.Web"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_dns_zone" "api_private_dns_zone" {
  name                = var.apim_private_domain
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "api_private_dns_zone_virtual_network_link" {
  name                  = format("%s-api-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.api_private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_a_record" "private_dns_a_record_api" {
  name                = local.apim_name
  zone_name           = azurerm_private_dns_zone.api_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  records             = module.apim.*.private_ip_addresses[0]
}
*/