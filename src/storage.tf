resource "azurerm_resource_group" "rg_storage" {
  name     = format("%s-storage-rg", local.project)
  location = var.location
  tags     = var.tags
}


## Storage account to save aks terraform state
module "aks_storage_account_terraform_state" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.5"

  name            = replace(format("%s-saaksinfra", local.project), "-", "")
  versioning_name = format("%s-sa-aksinfra-versioning", local.project)

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  enable_versioning        = true
  resource_group_name      = azurerm_resource_group.rg_aks.name
  location                 = var.location

  tags = var.tags
}

# Container to stare the status file
resource "azurerm_storage_container" "aks_state" {
  depends_on = [module.aks_storage_account_terraform_state]

  name                  = format("%s-aks-state", var.prefix)
  storage_account_name  = module.aks_storage_account_terraform_state.name
  container_access_type = "private"
}

## Storage account to save aks terraform state
module "cstarblobstorage" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.7"

  name                     = replace(format("%s-blobstorage", local.project), "-", "")
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  enable_versioning        = false
  resource_group_name      = azurerm_resource_group.rg_storage.name
  location                 = var.location
  allow_blob_public_access = true

  tags = var.tags
}

# Container terms and conditions
resource "azurerm_storage_container" "bpd_terms_and_conditions" {
  name                  = "bpd-terms-and-conditions"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "blob"
}

# Container export
resource "azurerm_storage_container" "cstar_exports" {
  name                  = "cstar-exports"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

# container info privacy
resource "azurerm_storage_container" "info_privacy" {
  name                  = "info-privacy"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "blob"
}