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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.25.2"
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

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.42.3
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=7dbbc06d591d3ce66536a7bdb2208b1370de04dd"
}
