terraform {
  required_version = ">= 1.3.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.99.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.48.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.12.0"
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
