terraform {
  required_version = ">=1.1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.99.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "> 2.10.0"
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

# provider "kubernetes" {
#   config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_cluster_name}"
# }

# provider "helm" {
#   kubernetes {
#     config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_cluster_name}"
#   }
# }
