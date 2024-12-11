terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.30"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.21.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "github" {
  owner = "pagopa"
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
