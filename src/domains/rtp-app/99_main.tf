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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "<= 2.30.2"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
