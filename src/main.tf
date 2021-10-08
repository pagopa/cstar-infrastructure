terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.76.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 1.6.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "Prod-Sec"
  subscription_id = data.azurerm_key_vault_secret.sec_sub_id.value
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

resource "azurerm_monitor_diagnostic_setting" "ActivityLog" {

  count                          = data.azurerm_key_vault_secret.sec_workspace_id[0].value != null ? 1 : 0
  name                           = "SecurityLogs"
  target_resource_id             = data.azurerm_key_vault_secret.sec_sub_id.value
  log_analytics_workspace_id     = data.azurerm_key_vault_secret.sec_workspace_id[0].value
  storage_account_id             = data.azurerm_key_vault_secret.sec_storage_id[0].value

  log {
    
    category = "Administrative"
    enabled = true
    retention_policy {
      enabled = true
      days = 365
    }
  }

  log {

    category  = "Security"
    enabled = true
    retention_policy {
      enabled = true
      days = 365
    }
  }
  
  log {
    
    category = "Alert"
    enabled = true 
    retention_policy {
      enabled = true
      days = 365
    }
  }
}

locals {
  project = format("%s-%s", var.prefix, var.env_short)
}
