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
  key_vault_id = data.azurerm_key_vault.general.id
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
  key_vault_id = data.azurerm_key_vault.general.id
  tags         = local.tags
}