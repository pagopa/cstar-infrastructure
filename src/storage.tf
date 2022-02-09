resource "azurerm_resource_group" "rg_storage" {
  name     = format("%s-storage-rg", local.project)
  location = var.location
  tags     = var.tags
}

## Storage account to save psql terraform state
module "psql_storage_account_terraform_state" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.5"

  name            = replace(format("%s-sapsqlinfra", local.project), "-", "")
  versioning_name = format("%s-sa-psqlinfra-versioning", local.project)

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  enable_versioning        = true
  resource_group_name      = azurerm_resource_group.db_rg.name
  location                 = var.location

  tags = var.tags
}

# Container to stare the status file
resource "azurerm_storage_container" "psql_state" {
  depends_on = [module.psql_storage_account_terraform_state]

  name                  = format("%s-psql-state", var.prefix)
  storage_account_name  = module.psql_storage_account_terraform_state.name
  container_access_type = "private"
}

## Storage account to save cstar blob
module "cstarblobstorage" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.1.26"

  name                     = replace(format("%s-blobstorage", local.project), "-", "")
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  enable_versioning        = false
  resource_group_name      = azurerm_resource_group.rg_storage.name
  location                 = var.location
  allow_blob_public_access = false
  
  network_rules = {

    default_action             = "Deny"
    bypass                     = ["Metrics", "AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = [module.storage_account_snet.id]
  }


  tags = var.tags
}

# Container terms and conditions
resource "azurerm_storage_container" "bpd_terms_and_conditions" {
  name                  = "bpd-terms-and-conditions"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "blob"
}

# Container terms and conditions
resource "azurerm_storage_container" "fa_terms_and_conditions" {
  name                  = "fa-terms-and-conditions"
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

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "cstar_blobstorage_key" {
  name         = "storageaccount-cstarblob-key"
  value        = module.cstarblobstorage.primary_access_key
  content_type = "text/plain"

  key_vault_id = module.key_vault.id
}

## Storage account to save logs
module "operations_logs" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.7"

  name                = replace(format("%s-sa-ops-logs", local.project), "-", "")
  versioning_name     = format("%s-sa-ops-versioning", local.project)
  resource_group_name = azurerm_resource_group.rg_storage.name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  enable_versioning        = true

  lock_enabled = true
  lock_name    = "storage-logs"
  lock_level   = "CanNotDelete"
  lock_notes   = null


  tags = var.tags
}

###########################
##         Blobs         ##
###########################

## Terms and Conditions HTML
data "local_file" "tc_html" {
  filename = "${path.module}/blob/tc/bpd-tc.html"
}
resource "null_resource" "upload_tc_html" {
  triggers = {
    "changes-in-config" : md5(data.local_file.tc_html.content)
  }
  provisioner "local-exec" {
    command = <<EOT
              az storage azcopy blob upload \
                --account-name ${module.cstarblobstorage.name} \
                --account-key ${module.cstarblobstorage.primary_access_key} \
                --container ${azurerm_storage_container.bpd_terms_and_conditions.name} \
                --source "${path.module}/blob/tc/bpd-tc.html"
          EOT
  }
}

## Terms and Conditions PDF
data "local_file" "tc_pdf" {
  filename = "${path.module}/blob/tc/bpd-tc.pdf"
}
resource "null_resource" "upload_tc_pdf" {
  triggers = {
    "changes-in-config" : md5(data.local_file.tc_pdf.content)
  }
  provisioner "local-exec" {
    command = <<EOT
              az storage azcopy blob upload \
                --account-name ${module.cstarblobstorage.name} \
                --account-key ${module.cstarblobstorage.primary_access_key} \
                --container ${azurerm_storage_container.bpd_terms_and_conditions.name} \
                --source "${path.module}/blob/tc/bpd-tc.pdf"
          EOT
  }
}
