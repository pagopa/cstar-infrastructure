resource "azurerm_private_dns_a_record" "ingress" {
  name                = "${var.domain}.${var.location_short}"
  zone_name           = data.azurerm_private_dns_zone.internal.name
  resource_group_name = local.internal_dns_zone_resource_group_name
  ttl                 = 3600
  records             = [var.ingress_load_balancer_ip]

  tags = local.tags
}

#
# Subnets
#

module "cosmosdb_mil_snet" {
  source               = "./.terraform/modules/__v4__/subnet"
  name                 = "${local.project}-cosmosb-snet"
  address_prefixes     = var.cidr_subnet_cosmosdb_mil
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name

  private_endpoint_network_policies = "Enabled"

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.AzureCosmosDB",
  ]
}

module "evenhub_mil_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-evhub-snet"
  address_prefixes     = var.cidr_subnet_eventhub_mil
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name

  private_endpoint_network_policies = "Enabled"
}

module "storage_mil_snet" {
  source = "./.terraform/modules/__v4__/subnet"


  name                 = "${local.project}-storage-snet"
  address_prefixes     = var.cidr_subnet_storage_mil
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name

  private_endpoint_network_policies = "Enabled"

  service_endpoints = [
    "Microsoft.Storage",
  ]
}

module "redis_mil_snet" {
  source = "./.terraform/modules/__v4__/subnet"

  name                 = "${local.project}-redis-snet"
  address_prefixes     = var.cidr_subnet_redis_mil
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name

  private_endpoint_network_policies = "Enabled"
}

