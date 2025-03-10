terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.21.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.0.2"
    }
    github = {
      source  = "integrations/github"
      version = "= 6.4.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "github" {
  owner = "pagopa"
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
