terraform {
  required_version = ">=0.15.3"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      version = "~> 2.60.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.13.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

data "azurerm_key_vault_secret" "psql_admin_username" {
  count = var.psql_username != null ? 0 : 1

  name         = "db-administrator-login"
  key_vault_id = local.key_vault_id
}


data "azurerm_key_vault_secret" "psql_admin_password" {
  count = var.psql_password != null ? 0 : 1

  name         = "db-administrator-login-password"
  key_vault_id = local.key_vault_id
}


provider "postgresql" {
  host             = var.psql_hostname
  port             = var.psql_port
  username         = "${local.psql_username}@${var.psql_servername}"
  password         = local.psql_password
  sslmode          = "require"
  expected_version = "10"
  superuser        = false
  connect_timeout  = 15
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
