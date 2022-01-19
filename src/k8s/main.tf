terraform {
  required_version = ">=0.15.3"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      version = "= 2.70.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 1.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.2.0"
    }
  }
}

provider "kubernetes" {
  host        = "https://${var.k8s_apiserver_host}:${var.k8s_apiserver_port}"
  insecure    = var.k8s_apiserver_insecure
  config_path = var.k8s_kube_config_path
}

provider "helm" {
  kubernetes {
    host        = "https://${var.k8s_apiserver_host}:${var.k8s_apiserver_port}"
    insecure    = var.k8s_apiserver_insecure
    config_path = var.k8s_kube_config_path
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
