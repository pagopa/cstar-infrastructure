resource "azurerm_resource_group" "rg_storage" {
  name     = format("%s-storage-rg", local.project)
  location = var.location
  tags     = var.tags
}

## Storage account to save cstar blob
module "cstarblobstorage" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.2.1"

  name                            = replace(format("%s-blobstorage", local.project), "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Hot"
  blob_versioning_enabled         = false
  resource_group_name             = azurerm_resource_group.rg_storage.name
  location                        = var.location
  allow_nested_items_to_be_public = false
  advanced_threat_protection      = true
  enable_low_availability_alert   = false
  public_network_access_enabled   = false
  tags                            = var.tags
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
  count = var.enable.rtd.hashed_pans_container ? 1 : 0

  name                  = "cstar-hashed-pans"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cstar_hashed_pans_par" {
  count = var.enable.rtd.hashed_pans_container ? 1 : 0

  name                  = "cstar-hashed-pans-par"
  storage_account_name  = module.cstarblobstorage.name
  container_access_type = "private"
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
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.2.1"

  name                = replace(format("%s-sa-ops-logs", local.project), "-", "")
  resource_group_name = azurerm_resource_group.rg_storage.name
  location            = var.location

  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = "GRS"
  access_tier                   = "Hot"
  blob_versioning_enabled       = true
  advanced_threat_protection    = true
  enable_low_availability_alert = false
  public_network_access_enabled = false
  tags                          = var.tags
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
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.2.1"

  name                            = replace(format("%s-backupstorage", local.project), "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  access_tier                     = "Cool"
  blob_versioning_enabled         = true
  resource_group_name             = azurerm_resource_group.rg_storage.name
  location                        = var.location
  allow_nested_items_to_be_public = false
  advanced_threat_protection      = true
  enable_low_availability_alert   = false
  public_network_access_enabled   = false
  tags                            = var.tags
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
