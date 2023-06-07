resource "azurerm_resource_group" "rg_storage" {
  name     = "${local.project}-storage-rg"
  location = var.location
  tags     = var.tags
}

## Storage account to save cstar blob
module "cstarblobstorage" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.2.1"

  name                             = replace("${local.project}-blobstorage", "-", "")
  account_kind                     = "StorageV2"
  account_tier                     = "Standard"
  account_replication_type         = var.env_short == "p" ? "RAGZRS" : "RAGRS"
  access_tier                      = "Hot"
  blob_versioning_enabled          = false
  resource_group_name              = azurerm_resource_group.rg_storage.name
  location                         = var.location
  allow_nested_items_to_be_public  = false
  advanced_threat_protection       = true
  enable_low_availability_alert    = false
  public_network_access_enabled    = true
  cross_tenant_replication_enabled = false
  tags                             = var.tags
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

  name                = replace("${local.project}-sa-ops-logs", "-", "")
  resource_group_name = azurerm_resource_group.rg_storage.name
  location            = var.location

  account_kind                  = "StorageV2"
  account_tier                  = "Standard"
  account_replication_type      = "GRS"
  access_tier                   = "Hot"
  blob_versioning_enabled       = true
  advanced_threat_protection    = true
  enable_low_availability_alert = false
  public_network_access_enabled = true
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
  count  = 1
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.2.1"

  name                            = replace("${local.project}-backupstorage", "-", "")
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

resource "azurerm_private_endpoint" "backupstorage_private_endpoint" {
  count = 1

  name                = "${local.project}-backupstorage-private-endpoint"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_storage.name
  subnet_id           = module.private_endpoint_snet[0].id

  private_dns_zone_group {
    name                 = "${local.project}-backupstorage-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account.id]
  }

  private_service_connection {
    name                           = "${local.project}-backupstorage-private-service-connection"
    private_connection_resource_id = module.backupstorage[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  depends_on = [
    module.backupstorage
  ]
}

resource "azurerm_storage_container" "apim_backup" {
  count                 = 1
  name                  = "apim"
  storage_account_name  = module.backupstorage[0].name
  container_access_type = "private"

  depends_on = [
    azurerm_private_endpoint.backupstorage_private_endpoint
  ]
}

resource "azurerm_storage_management_policy" "backups" {
  count              = 1
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

  depends_on = [
    azurerm_private_endpoint.backupstorage_private_endpoint
  ]
}
