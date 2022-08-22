data "azurerm_storage_account" "acquirer_sa" {
  name                = replace("${local.product}-blobstorage", "-", "")
  resource_group_name = "${local.product}-storage-rg"
}

data "azurerm_storage_account" "sftp_sa" {
  name                = replace("${local.product}-sftp", "-", "")
  resource_group_name = "${local.product}-sftp-rg"
}


#
# Diagnostic settings
#
resource "azurerm_monitor_diagnostic_setting" "log_acquirer_sa" {
  count                          = true ? 1 : 0
  name                           = "LogAcquirerBlob"
  target_resource_id             = format("%s/blobServices/default", data.azurerm_storage_account.acquirer_sa.id)
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.log_analytics.id
  # storage_account_id             = var.sec_storage_id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 90
    }
  }

  metric {
    category = "Transaction"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}