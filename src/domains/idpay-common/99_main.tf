terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
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

data "azurerm_dns_zone" "public" {
  name                = join(".", [var.dns_zone_prefix, var.external_domain])
  resource_group_name = local.vnet_core_resource_group_name
}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.42.3
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=7dbbc06d591d3ce66536a7bdb2208b1370de04dd"
}

# module "__next_v3__" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3//redis_cache?ref=redis-update"
# }
