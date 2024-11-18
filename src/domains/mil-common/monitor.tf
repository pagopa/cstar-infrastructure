# ------------------------------------------------------------------------------
# Log Analytics Workspace.
# ------------------------------------------------------------------------------
variable "core_log_analytics_workspace_name" {
  type = string
}

variable "core_log_analytics_workspace_resource_group_name" {
  type = string
}

data "azurerm_log_analytics_workspace" "core" {
  name                = var.core_log_analytics_workspace_name
  resource_group_name = var.core_log_analytics_workspace_resource_group_name
}

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
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}

# ------------------------------------------------------------------------------
# Query pack.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack" "mil" {
  name                = "${local.project}-pack"
  location            = azurerm_resource_group.monitor.location
  resource_group_name = azurerm_resource_group.monitor.name
  tags                = local.tags
}