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

  # Must be added is a subsequent PR, since it inhibits terraform access to containers state

  # network_rules = {

  #   default_action             = "Deny"
  #   bypass                     = ["Metrics", "AzureServices"]
  #   ip_rules                   = []
  #   virtual_network_subnet_ids = [module.apim_snet.id]
  # }


  tags = var.tags
}

resource "azurerm_role_assignment" "data_contributor_role" {
  scope                = module.cstarblobstorage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.apim.principal_id

  depends_on = [
    module.cstarblobstorage
  ]
}

# Container terms and conditions
resource "azurerm_storage_container" "bpd_terms_and_conditions" {
  name                  = "bpd-terms-and-conditions"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}


resource "null_resource" "auth_bpd_tc_container" {

  triggers = {
    apim_principal_id = module.apim.principal_id
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage container set-permission \
                --name ${azurerm_storage_container.bpd_terms_and_conditions.name} \
                --account-name ${module.cstarblobstorage.name} \
                --account-key ${module.cstarblobstorage.primary_access_key} \
                --auth-mode login
          EOT
  }

  depends_on = [
    azurerm_storage_container.bpd_terms_and_conditions
  ]
}

# Container terms and conditions
resource "azurerm_storage_container" "fa_terms_and_conditions" {
  name                  = "fa-terms-and-conditions"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

resource "null_resource" "auth_fa_tc_container" {

  triggers = {
    apim_principal_id = module.apim.principal_id
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage container set-permission \
                --name ${azurerm_storage_container.fa_terms_and_conditions.name} \
                --account-name ${module.cstarblobstorage.name} \
                --account-key ${module.cstarblobstorage.primary_access_key} \
                --auth-mode login
          EOT
  }

  depends_on = [
    azurerm_storage_container.fa_terms_and_conditions
  ]
}

# container info privacy
resource "azurerm_storage_container" "info_privacy" {
  name                  = "info-privacy"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

resource "null_resource" "auth_info_privacy" {

  triggers = {
    apim_principal_id = module.apim.principal_id
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage container set-permission \
                --name ${azurerm_storage_container.info_privacy.name} \
                --account-name ${module.cstarblobstorage.name} \
                --account-key ${module.cstarblobstorage.primary_access_key} \
                --auth-mode login
          EOT
  }

  depends_on = [
    azurerm_storage_container.info_privacy
  ]
}

# Container export
resource "azurerm_storage_container" "cstar_exports" {
  name                  = "cstar-exports"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cstar_hashed_pans" {
  name                  = "cstar-hashed-pans"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"

  count = var.enable.rtd.hashed_pans_container ? 1 : 0
}

# Container transaction decrypted RTD
resource "azurerm_storage_container" "rtd_transactions_decrypted" {
  name                  = "rtd-transactions-decrypted"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
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



# Storage account to store backups: mainly api management
module "backupstorage" {
  count  = var.env_short == "p" ? 1 : 0
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.1.26"

  name                     = replace(format("%s-backupstorage", local.project), "-", "")
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Cool"
  enable_versioning        = true
  versioning_name          = "versioning"
  resource_group_name      = azurerm_resource_group.rg_storage.name
  location                 = var.location
  allow_blob_public_access = false

  tags = var.tags
}

resource "azurerm_storage_container" "apim_backup" {
  count                 = var.env_short == "p" ? 1 : 0
  name                  = "apim"
  storage_account_name  = module.backupstorage[0].name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "backups" {
  count              = var.env_short == "p" ? 1 : 0
  storage_account_id = module.backupstorage[0].id

  rule {
    name    = "deleteafterdays"
    enabled = true
    filters {
      prefix_match = [azurerm_storage_container.apim_backup[0].name]
      blob_types   = ["blockBlob", "appendBlob"]
    }
    actions {
      version {
        delete_after_days_since_creation = 20
      }
    }
  }
}