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
  count                      = var.acquirer_storage_params.analytics_workspace_enabled ? 1 : 0
  name                       = "LogAcquirerBlob"
  target_resource_id         = "${data.azurerm_storage_account.acquirer_sa.id}/blobServices/default"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
  # storage_account_id             = var.sec_storage_id
  # log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_sftp_sa" {
  count                      = var.sftp_storage_params.analytics_workspace_enabled ? 1 : 0
  name                       = "LogSftpBlob"
  target_resource_id         = "${data.azurerm_storage_account.sftp_sa.id}/blobServices/default"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id
  # storage_account_id             = var.sec_storage_id
  # log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = false
  }

}
