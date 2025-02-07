# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to auth key vault.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "auth_key_vault" {
  name                = "${local.project}-auth-kv-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-auth-kv-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-auth-kv-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-auth-kv-psc"
    private_connection_resource_id = azurerm_key_vault.auth.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Storing auth key vault URL in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "key_vault_auth_vault_uri" {
  name         = "key-vault-auth-vault-uri"
  value        = azurerm_key_vault.auth.vault_uri
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from "private endpoints" subnet to auth key vault for VPN.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "auth_key_vault_vpn" {
  name                = "${local.project}-auth-kv-vpn-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  custom_network_interface_name = "${local.project}-auth-kv-vpn-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-auth-kv-vpn-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-auth-kv-vpn-psc"
    subresource_names              = ["vault"]
    private_connection_resource_id = azurerm_key_vault.auth.id
    is_manual_connection           = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "general_key_vault" {
  name                = "${local.project}-gen-kv-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-gen-kv-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-gen-kv-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-gen-kv-psc"
    private_connection_resource_id = azurerm_key_vault.general.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from "private endpoints" subnet to general key vault for VPN.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "general_key_vault_vpn" {
  name                = "${local.project}-gen-kv-vpn-pep"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  custom_network_interface_name = "${local.project}-gen-kv-vpn-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-gen-kv-vpn-pdzg"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-gen-kv-vpn-psc"
    subresource_names              = ["vault"]
    private_connection_resource_id = azurerm_key_vault.general.id
    is_manual_connection           = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to CosmosDB.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "cosmos" {
  name                = "${local.project}-cosmos-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-cosmos-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.cosmos.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.mcshared.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }

  tags = local.tags
}