terraform {
  required_version = ">=0.15.3"

  backend "azurerm" {
    container_name = "cstar-psql-state"
    key            = "terraform-cstar-psql.tfstate"
  }

  required_providers {
    azurerm = {
      version = "~> 2.60.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.13.0"
    }
  }
}

data "azurerm_key_vault_secret" "psql_admin_password" {
  count = var.psql_password != null ? 1 : 0

  name         = "db-administrator-password"
  key_vault_id = local.key_vault_id
}


provider "postgresql" {
  host            = var.psql_hostname
  port            = var.psql_port
  username        = "${var.psql_username}@${var.psql_servername}"
  password        = var.psql_password != null ? var.psql_password : data.azurerm_key_vault_secret.psql_admin_password[0].value
  sslmode         = "require"
  superuser       = false
  connect_timeout = 15
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
