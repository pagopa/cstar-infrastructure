resource "azurerm_resource_group" "db_rg" {
  name     = format("%s-db-rg", local.project)
  location = var.location

  tags = var.tags
}

data "azurerm_key_vault_secret" "db_administrator_login" {
  name         = "db-administrator-login"
  key_vault_id = module.key_vault.id
}

data "azurerm_key_vault_secret" "db_administrator_login_password" {
  name         = "db-administrator-login-password"
  key_vault_id = module.key_vault.id
}

module "postgresql" {
  source                           = "git::https://github.com/pagopa/azurerm.git//postgresql_server?ref=main"
  name                             = format("%s-postgresql", local.project)
  location                         = azurerm_resource_group.db_rg.location
  resource_group_name              = azurerm_resource_group.db_rg.name
  virtual_network_id               = module.vnet.id
  subnet_id                        = module.db_snet.id
  administrator_login              = data.azurerm_key_vault_secret.db_administrator_login.value
  administrator_login_password     = data.azurerm_key_vault_secret.db_administrator_login_password.value
  sku_name                         = var.db_sku_name
  db_version                       = 10
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = var.tags
}
