terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.99.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.21.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=0.1.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.1.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 4.0.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.5.1"
    }
    local = {
      source = "hashicorp/local"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
  }
}
