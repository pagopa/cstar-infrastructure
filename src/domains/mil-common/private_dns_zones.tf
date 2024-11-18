# ------------------------------------------------------------------------------
# Private DNS zone for ACA.
# ------------------------------------------------------------------------------
variable "aca_private_dns_zone_resource_group" {
  type = string
}

data "azurerm_private_dns_zone" "aca" {
  name                = data.azurerm_container_app_environment.mil.default_domain
  resource_group_name = var.aca_private_dns_zone_resource_group
}

# ------------------------------------------------------------------------------
# Private DNS zone for key vaults.
# ------------------------------------------------------------------------------
variable "key_vault_private_dns_zone_resource_group_name" {
  type = string
}

data "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.key_vault_private_dns_zone_resource_group_name
}

# ------------------------------------------------------------------------------
# Private DNS zone for storages.
# ------------------------------------------------------------------------------
variable "core_integr_virtual_network_resource_group_name" {
  type = string
}

data "azurerm_private_dns_zone" "storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.core_integr_virtual_network_resource_group_name
}

# ------------------------------------------------------------------------------
# Private DNS zone for CosmosDB.
# ------------------------------------------------------------------------------
data "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.core_integr_virtual_network_resource_group_name
}

# ------------------------------------------------------------------------------
# Private DNS zone Redis.
# ------------------------------------------------------------------------------
data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.core_integr_virtual_network_resource_group_name
}