# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to idpay key vault.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "idpay_key_vault" {
  name                = "${local.project}-idpay-kv-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-idpay-kv-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-idpay-kv-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-idpay-kv-psc"
    private_connection_resource_id = azurerm_key_vault.idpay.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Storing auth key vault URL in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "key_vault_idpay_vault_uri" {
  name         = "key-vault-idpay-vault-uri"
  value        = azurerm_key_vault.idpay.vault_uri
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from "private endpoints" subnet to idpay key vault for VPN.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "idpay_key_vault_vpn" {
  name                = "${local.project}-idpay-kv-vpn-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  custom_network_interface_name = "${local.project}-idpay-kv-vpn-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-idpay-kv-vpn-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.key_vault.id]
  }

  private_service_connection {
    name                           = "${local.project}-idpay-kv-vpn-psc"
    subresource_names              = ["vault"]
    private_connection_resource_id = azurerm_key_vault.idpay.id
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
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-gen-kv-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-gen-kv-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.key_vault.id]
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
    private_dns_zone_ids = [data.azurerm_private_dns_zone.key_vault.id]
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
# Private endpoint from ACA subnet to the storage account containing
# configuration files for payment-notice and fee-calculator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "conf_storage" {
  name                = "${local.project}-conf-storage-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-conf-storage-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-conf-storage-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage.id]
  }

  private_service_connection {
    name                           = "${local.project}-conf-storage-psc"
    private_connection_resource_id = azurerm_storage_account.conf.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Storing storage account blob endpoint in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "storage_account_conf_primary_blob_endpoint" {
  name         = "storage-account-conf-primary-blob-endpoint"
  value        = azurerm_storage_account.conf.primary_blob_endpoint
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to CosmosDB.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "cosmos" {
  name                = "${local.project}-cosmos-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-cosmos-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-cosmos-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.cosmos.id]
  }

  private_service_connection {
    name                           = "${local.project}-cosmos-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.mil.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }

  tags = local.tags
}

# ------------------------------------------------------------------------------
# Private endpoint from ACA subnet to Redis.
# ------------------------------------------------------------------------------
resource "azurerm_private_endpoint" "redis" {
  name                = "${local.project}-redis-pep"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  subnet_id           = data.azurerm_subnet.aca.id

  custom_network_interface_name = "${local.project}-redis-pep-nic"

  private_dns_zone_group {
    name                 = "${local.project}-redis-pdzg"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }

  private_service_connection {
    name                           = "${local.project}-redis-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.mil.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  tags = local.tags
}