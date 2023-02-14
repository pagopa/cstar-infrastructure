#
# Storage for Audit Logs Data


#tfsec:ignore:azure-storage-default-action-deny
module "idpay_audit_log_immutable_storage" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"

  #Required
  name                              = replace("${var.domain}${var.env_short}-audit-log-imm-storage", "-", "")
  location                          = var.location
  resource_group_name               = azurerm_resource_group.rg_refund_storage.name
  account_tier                      = "Standard"
  account_replication_type          = var.storage_account_replication_type #Default LRS
          
  #Optional       
  account_kind                      = "StorageV2"
  access_tier                       = "Hot"
  versioning_name                   = "${var.domain}${var.env_short}-audit-log-imm-storage-versioning"
  enable_versioning                 = var.storage_enable_versioning
  advanced_threat_protection        = var.storage_advanced_threat_protection
  # infrastructure_encryption_enabled = true

  tags = var.tags
}

resource "azurerm_storage_container" "idpay_audit_log_immutable_container" {
  name                  = "audit-logo"
  storage_account_name  = module.idpay_audit_log_immutable_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_encryption_scope" "idpay_audit_log_immutable_storage_encryption_scope" {
  name                                = "microsoftmanaged"
  storage_account_id                  = module.idpay_audit_log_immutable_storage.id
  source                              = "Microsoft.Storage"
  #Optional
  infrastructure_encryption_required  = true
}

# storage access key

# resource "azurerm_key_vault_secret" "audit_log_immutable_storage_access_key" {
#   name         = "audit-log-immutable-storage-access-key"
#   value        = module.idpay_audit_log_immutable_storage.primary_access_key
#   content_type = "text/plain"

#   key_vault_id = data.azurerm_key_vault.kv.id
# }

# #tfsec:ignore:azure-keyvault-ensure-secret-expiry
# resource "azurerm_key_vault_secret" "audit_log_immutable_storage_connection_string" {
#   name         = "audit-log-immutable-storage-connection-string"
#   value        = module.idpay_audit_log_immutable_storage.primary_connection_string
#   content_type = "text/plain"

#   key_vault_id = data.azurerm_key_vault.kv.id
# }

# #tfsec:ignore:azure-keyvault-ensure-secret-expiry
# resource "azurerm_key_vault_secret" "audit_log_immutable_storage_blob_connection_string" {
#   name         = "audit-log-immutable-storage-blob-connection-string"
#   value        = module.idpay_audit_log_immutable_storage.primary_blob_connection_string
#   content_type = "text/plain"

#   key_vault_id = data.azurerm_key_vault.kv.id
# }



resource "azapi_update_resource" "idpay_audit_log_immutable_container_immutability_policy" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2022-05-01"
  name = replace("${var.domain}${var.env_short}-audit-log-imm-storage", "-", "")
  parent_id = azurerm_storage_container.idpay_audit_log_immutable_container.id
          
  body = jsonencode({
    properties = {
      # encryption = {
      #   keySource = "Microsoft.Storage"
      #   requireInfrastructureEncryption = true
      #   services = {
      #     blob = {
      #       enabled = true
      #       keyType = "Account"
      #     }
      #     file = {
      #       enabled = true
      #       keyType = "Account"
      #     }
      #   }
      # }
      allowProtectedAppendWrites            = true
      # allowProtectedAppendWritesAll         = null
      immutabilityPeriodSinceCreationInDays = 300
      state = "Unlocked" #Unlocked state allows increase and decrease of immutability retention time
    }
  })
  # response_export_values = ["*"]
}