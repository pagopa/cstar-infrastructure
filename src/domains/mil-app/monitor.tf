# ------------------------------------------------------------------------------
# Application insights.
# ------------------------------------------------------------------------------
variable "core_application_insights_name" {
  type = string
}

variable "core_application_insights_resource_group_name" {
  type = string
}

data "azurerm_application_insights" "core" {
  name                = var.core_application_insights_name
  resource_group_name = var.core_application_insights_resource_group_name
}

# ------------------------------------------------------------------------------
# Storing Application Insights connection strings in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "core_application_insigths_connection_string" {
  name         = "core-application-insigths-connection-string"
  value        = data.azurerm_application_insights.core.connection_string
  key_vault_id = data.azurerm_key_vault.general.id
  tags         = local.tags
}