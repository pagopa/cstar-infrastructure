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

# 🔒 KV
data "azurerm_key_vault" "kv_domain" {
  name                = local.kv_domain_name
  resource_group_name = local.kv_domain_rg_name
}

# 📊 Monitoring
data "azurerm_resource_group" "monitor_weu_rg" {
  name = local.monitor_weu_resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics_weu" {
  name                = local.log_analytics_weu_workspace_name
  resource_group_name = local.log_analytics_weu_workspace_resource_group_name
}

data "azurerm_application_insights" "application_insights_weu" {
  name                = local.monitor_appinsights_name
  resource_group_name = data.azurerm_resource_group.monitor_weu_rg.name
}

data "azurerm_monitor_action_group" "slack" {
  resource_group_name = data.azurerm_resource_group.monitor_weu_rg.name
  name                = local.monitor_action_group_slack_name
}

data "azurerm_monitor_action_group" "email" {
  resource_group_name = data.azurerm_resource_group.monitor_weu_rg.name
  name                = local.monitor_action_group_email_name
}

# 🛜 VNET
data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

# 🔎 DNS
data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "cosmos" {
  name                = local.cosmos_dns_zone_name
  resource_group_name = local.cosmos_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "eventhub" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}

# 🐳 Kubernetes Cluster
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.aks_resource_group_name
}
