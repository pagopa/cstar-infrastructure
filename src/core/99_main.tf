terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.102"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.48"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.3"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
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

provider "azurerm" {
  alias           = "Prod-Sec"
  subscription_id = data.azurerm_key_vault_secret.sec_sub_id.value
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.68.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=b9dd50d01d7785bdfd47dc8be927df7801512286"
}
