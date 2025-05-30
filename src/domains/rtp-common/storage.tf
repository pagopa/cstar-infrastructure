resource "azurerm_resource_group" "rtp_rg_storage" {
  name     = "${local.project}-storage-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "rtp_blob_storage_account" {
  name                             = replace("${local.project}-blobstorage", "-", "")
  resource_group_name              = azurerm_resource_group.rtp_rg_storage.name
  location                         = var.location
  account_kind                     = "StorageV2"
  account_tier                     = "Standard"
  account_replication_type         = var.env_short == "p" ? "RAGZRS" : "RAGRS"
  access_tier                      = "Hot"
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  is_hns_enabled                   = false
  cross_tenant_replication_enabled = false
  public_network_access_enabled    = true
  sftp_enabled                     = false
  tags                             = var.tags
}


resource "azurerm_security_center_storage_defender" "rtp_blob_storage_account_storage_defender" {
  storage_account_id = azurerm_storage_account.rtp_blob_storage_account.id
}


resource "azurerm_storage_container" "rtp_debtor_service_provider" {
  name                  = "rtp-debtor-service-provider"
  storage_account_name  = azurerm_storage_account.rtp_blob_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "rtp_payees_registry" {
  name                  = "rtp-payees-registry"
  storage_account_name  = azurerm_storage_account.rtp_blob_storage_account.name
  container_access_type = "private"
}
