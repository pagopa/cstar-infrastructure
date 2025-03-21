# 🔒 KV
data "azurerm_key_vault" "kv_domain" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

# 📥 Eventhub
data "azurerm_eventhub_namespace" "eventhub_mil" {
  name                = local.eventhub_mil_namespace_name
  resource_group_name = local.eventhub_mil_namespace_rg_name
}

# 📊 Monitoring
data "azurerm_resource_group" "monitor_rg" {
  name = var.monitor_resource_group_name
}

data "azurerm_application_insights" "application_insights" {
  name                = local.monitor_appinsights_name
  resource_group_name = var.monitor_resource_group_name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = var.monitor_resource_group_name
  name                = local.monitor_action_group_email_name
}

# 🐳 Kubernetes Cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

# 🔗 API Management
data "azurerm_api_management" "apim_core" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

# 🔑 Azure AD
data "azuread_group" "adgroup_admin" {
  display_name = "${local.product}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.product}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.product}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.product}-adgroup-security"
}
