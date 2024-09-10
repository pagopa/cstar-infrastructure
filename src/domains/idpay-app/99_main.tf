terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=0.1.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    local = {
      source = "hashicorp/local"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.0.1"
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

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.43.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=cdbffbb3215b0eb047ae61408f042c246f0f914c"
}

# module "__next_v3__" {
#   source = "git::https://github.com/pagopa/terraform-azurerm-v3//redis_cache?ref=redis-update"
# }
