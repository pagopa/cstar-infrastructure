terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.38.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.21.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.1.1"
    }
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "0.0.7"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "terraform_remote_state" "core" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.terraform_remote_state_core.resource_group_name
    storage_account_name = var.terraform_remote_state_core.storage_account_name
    container_name       = var.terraform_remote_state_core.container_name
    key                  = var.terraform_remote_state_core.key
  }
}

#NOT USED
#data "azurerm_dns_zone" "public" {
#  name                = join(".", [var.env, var.dns_zone_prefix, var.external_domain])
#  resource_group_name = local.vnet_core_resource_group_name
#}
