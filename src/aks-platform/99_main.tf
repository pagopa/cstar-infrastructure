terraform {
  required_version = ">=1.3.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.114.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 2.53.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "<= 2.3.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "<= 2.31.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "<= 2.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "<= 3.2.2"
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

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_cluster_name}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_cluster_name}"
  }
}

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.86.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=d2b9a60c74ecfb248506e7573062bdf653ce9f99"
}
