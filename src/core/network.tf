resource "azurerm_resource_group" "rg_vnet" {
  name     = "${local.project}-vnet-rg"
  location = var.location

  tags = var.tags
}

# MAIN VNET
module "vnet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.2.1"
  name                 = "${local.project}-vnet"
  location             = azurerm_resource_group.rg_vnet.location
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  address_space        = var.cidr_vnet
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

## Peering between the vnet(main) and integration vnet
module "vnet_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.2.1"

  location = azurerm_resource_group.rg_vnet.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet.name
  source_remote_virtual_network_id = module.vnet.id
  source_allow_gateway_transit     = true
  # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet_integration.name
  target_remote_virtual_network_id = module.vnet_integration.id
  target_use_remote_gateways       = false # needed by vnet peering with SIA
}

# vnet integration
module "vnet_integration" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.2.1"
  name                 = "${local.project}-integration-vnet"
  location             = azurerm_resource_group.rg_vnet.location
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  address_space        = var.cidr_integration_vnet
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

#
# Subnet
#

## Database subnet
module "db_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-db-snet"
  address_prefixes                          = var.cidr_subnet_db
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  service_endpoints                         = ["Microsoft.Sql"]
  private_endpoint_network_policies_enabled = false
}

module "cosmos_mongodb_snet" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                 = "${local.project}-cosmos-mongodb-snet"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_cosmos_mongodb

  private_endpoint_network_policies_enabled = false
  service_endpoints                         = ["Microsoft.Web"]
}

module "private_endpoint_snet" {
  count = var.enable.core.private_endpoints_subnet ? 1 : 0

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                 = "private-endpoint-snet"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_private_endpoint

  private_endpoint_network_policies_enabled = false
  service_endpoints = [
    "Microsoft.Web", "Microsoft.AzureCosmosDB", "Microsoft.EventHub"
  ]
}

module "redis_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  count                = var.redis_sku_name == "Premium" && length(var.cidr_subnet_redis) > 0 ? 1 : 0
  name                 = "${local.project}-redis-snet"
  address_prefixes     = var.cidr_subnet_redis
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
}

# k8s cluster subnet
module "k8s_snet" {

  count = 0

  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-k8s-snet"
  address_prefixes                          = var.cidr_subnet_k8s
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = false

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub"
  ]
}

moved {
  from = module.k8s_snet
  to   = module.k8s_snet[0]
}

## Subnet jumpbox
module "jumpbox_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-jumpbox-snet"
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  address_prefixes                          = var.cidr_subnet_jumpbox
  private_endpoint_network_policies_enabled = true

}

module "azdoa_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  count                                     = var.enable_azdoa ? 1 : 0
  name                                      = "${local.project}-azdoa-snet"
  address_prefixes                          = var.cidr_subnet_azdoa
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = false
}

# Subnet to host the application gateway
module "appgateway-snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-appgateway-snet"
  address_prefixes                          = var.cidr_subnet_appgateway
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = true
}

# APIM subnet
module "apim_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                 = "${local.project}-apim-snet"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet_integration.name
  address_prefixes     = var.cidr_subnet_apim

  service_endpoints = ["Microsoft.Web", "Microsoft.Storage"]

  private_endpoint_network_policies_enabled = false
}

## Eventhub subnet
module "eventhub_snet" {

  count = 1

  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-eventhub-snet"
  address_prefixes                          = var.cidr_subnet_eventhub
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_integration.name
  service_endpoints                         = ["Microsoft.EventHub"]
  private_endpoint_network_policies_enabled = false
}

moved {
  from = module.eventhub_snet
  to   = module.eventhub_snet[0]
}

# Subnet for Azure Data Factory
module "adf_snet" {

  count = var.enable.tae.adf ? 1 : 0


  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-adf-snet"
  address_prefixes                          = var.cidr_subnet_adf
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = false

  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub"
  ]
}

#
# PUBLIC IP
#

## Application gateway public ip ##
resource "azurerm_public_ip" "appgateway_public_ip" {
  name                = "${local.project}-appgateway-maz-pip"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  // availability_zone   = var.app_gateway_public_ip_availability_zone
  zones = [1, 2, 3]

  tags = var.tags
}

resource "azurerm_public_ip" "apim_v2_management_public_ip" {
  name                = "${local.project}-apim-management-pip"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  location            = var.location
  sku                 = "Standard"
  domain_name_label   = "apim-management-${var.env_short}-cstar"
  allocation_method   = "Static"

  zones = var.apim_v2_zones

  tags = var.tags
}

#
# ROUTING
#
module "route_table_peering_sia" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//route_table?ref=v6.2.1"

  name                          = "${local.project}-sia-rt"
  location                      = azurerm_resource_group.rg_vnet.location
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  disable_bgp_route_propagation = false

  subnet_ids = [module.apim_snet.id]

  routes = [
    {
      # production
      name                   = "to-sia-prod-subnet"
      address_prefix         = "10.70.132.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-sia-uat-subnet"
      address_prefix         = "10.70.67.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-apim-sia-uat-subnet"
      address_prefix         = "10.70.65.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # prod
      name                   = "to-apim-sia-prod-subnet"
      address_prefix         = "10.70.133.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # prod
      name                   = "to-haproxy-sia-prod-subnet"
      address_prefix         = "10.70.131.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # dev
      name                   = "to-aks-nexi-dev-subnet"
      address_prefix         = "10.70.66.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # dev
      name                   = "to-payment-manager-nexi-dev-subnet"
      address_prefix         = "10.70.68.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-aks-nexi-uat-subnet"
      address_prefix         = "10.70.74.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-payment-manager-nexi-uat-subnet"
      address_prefix         = "10.70.72.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-blob-pci-nexi-uat-subnet"
      address_prefix         = "10.70.73.32/27"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
  ]

  tags = var.tags
}

# Azure Blob Storage subnet
module "storage_account_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = "${local.project}-storage-account-snet"
  address_prefixes                          = var.cidr_subnet_storage_account
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  service_endpoints                         = ["Microsoft.Storage"]
  private_endpoint_network_policies_enabled = false
}

#
# Private endpoint
#
resource "azurerm_private_endpoint" "blob_storage_pe" {
  name                = "${local.project}-blob-storage-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  subnet_id           = module.storage_account_snet.id

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.storage_account.name
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account.id]
  }
  private_service_connection {
    name                           = "${local.project}-blob-storage-private-service-connection"
    is_manual_connection           = false
    private_connection_resource_id = module.cstarblobstorage.id
    subresource_names              = ["blob"]
  }

}

resource "azurerm_private_endpoint" "dexp_pe" {

  count = var.dexp_params.enabled ? 1 : 0

  name                          = "${local.project}-dexp-priv-endpoint"
  custom_network_interface_name = "${local.project}-dexp-priv-endpoint-nic"
  location                      = azurerm_resource_group.monitor_rg.location
  resource_group_name           = azurerm_resource_group.monitor_rg.name
  subnet_id                     = module.private_endpoint_snet[count.index].id

  private_service_connection {
    name                           = "${local.project}-dexp-priv-endpoint"
    private_connection_resource_id = azurerm_kusto_cluster.data_explorer_cluster[count.index].id
    is_manual_connection           = false
    subresource_names              = ["cluster"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.kusto.id,
      azurerm_private_dns_zone.storage_account.id,
      azurerm_private_dns_zone.queue.id,
      azurerm_private_dns_zone.table.id

    ]
  }
}

#
# NSG
#
resource "azurerm_network_security_group" "apim_v2_snet_nsg" {
  name                = "${local.project}-apimv2-snet-nsg"
  location            = var.location
  resource_group_name  = azurerm_resource_group.rg_vnet.name
}


resource "azurerm_network_security_rule" "apim_v2_snet_nsg_rules" {
  count = length(var.apim_v2_subnet_nsg_security_rules)

  network_security_group_name = azurerm_network_security_group.apim_v2_snet_nsg.name
  name                        = var.apim_v2_subnet_nsg_security_rules[count.index].name
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  priority                    = var.apim_v2_subnet_nsg_security_rules[count.index].priority
  direction                   = var.apim_v2_subnet_nsg_security_rules[count.index].direction
  access                      = var.apim_v2_subnet_nsg_security_rules[count.index].access
  protocol                    = var.apim_v2_subnet_nsg_security_rules[count.index].protocol
  source_port_range           = var.apim_v2_subnet_nsg_security_rules[count.index].source_port_range
  destination_port_range      = var.apim_v2_subnet_nsg_security_rules[count.index].destination_port_range
  source_address_prefix       = var.apim_v2_subnet_nsg_security_rules[count.index].source_address_prefix
  destination_address_prefix  = var.apim_v2_subnet_nsg_security_rules[count.index].destination_address_prefix
}

resource "azurerm_subnet_network_security_group_association" "apim_stv2_snet_link_nsg" {
  subnet_id                 = module.apim_snet.id
  network_security_group_id = azurerm_network_security_group.apim_v2_snet_nsg.id
}
