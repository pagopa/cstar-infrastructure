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
  subscription_id = "0da48c97-355f-4050-a520-f11a18b8be90"

  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

locals {
  project = format("%s-%s", var.prefix, var.env_short)
}
