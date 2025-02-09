# ------------------------------------------------------------------------------
# Private DNS zone for ACA.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "aca" {
  name                = azurerm_container_app_environment.mcshared.default_domain
  resource_group_name = azurerm_resource_group.network.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca_to_intern" {
  name                  = data.azurerm_virtual_network.intern.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.aca.name
  virtual_network_id    = data.azurerm_virtual_network.intern.id
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca_to_integr" {
  name                  = data.azurerm_virtual_network.integr.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.aca.name
  virtual_network_id    = data.azurerm_virtual_network.integr.id
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "aca_to_core" {
  name                  = data.azurerm_virtual_network.core.name
  resource_group_name   = azurerm_resource_group.network.name
  private_dns_zone_name = azurerm_private_dns_zone.aca.name
  virtual_network_id    = data.azurerm_virtual_network.core.id
  tags                  = local.tags
}

resource "azurerm_private_dns_a_record" "aca" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.aca.name
  resource_group_name = azurerm_resource_group.network.name
  ttl                 = 3600
  tags                = local.tags
  records             = [azurerm_container_app_environment.mcshared.static_ip_address]
}

# ------------------------------------------------------------------------------
# Private DNS zone for key vaults.
#
# TODO: To be moved to core.
# ------------------------------------------------------------------------------
resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.network.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_to_intern" {
  name                  = "key_vault_to_intern"
  resource_group_name   = azurerm_private_dns_zone.key_vault.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = data.azurerm_virtual_network.intern.id
  tags                  = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_to_core" {
  name                  = "key_vault_to_core"
  resource_group_name   = azurerm_private_dns_zone.key_vault.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = data.azurerm_virtual_network.core.id
  tags                  = local.tags
}

# ------------------------------------------------------------------------------
# Private DNS zone for CosmosDB.
# ------------------------------------------------------------------------------
data "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.core_integr_virtual_network_resource_group_name
}