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
  alias           = "Prod-Sec"
￼ subscription_id = data.azurerm_key_vault_secret.prod_sec_sub.value
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

locals {
  project = format("%s-%s", var.prefix, var.env_short)
}
