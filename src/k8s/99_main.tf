terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      version = ">= 3.53.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.39.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.17.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8.0"
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
