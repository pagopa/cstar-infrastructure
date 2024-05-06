terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.101.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 2.48.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "<= 3.6.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "<= 2.3.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "<= 3.2.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "<= 4.1.0"
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
