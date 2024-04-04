#
# Local Variables
#
locals {
  log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
  audit_dce_name               = "${var.domain}${var.env_short}-audit-dce"
  audit_dcr_name               = "${var.domain}${var.env_short}-audit-dcr"
  audit_dcra_name              = "${var.domain}${var.env_short}-audit-dcra"
  subscription_id              = data.azurerm_subscription.current.subscription_id
  resource_group_name          = data.azurerm_application_insights.application_insights.resource_group_name
  audit_dce_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionEndpoints/${local.audit_dce_name}"
  audit_dcr_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}"
  az_rest_api_dcr              = "https://management.azure.com/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}?api-version=2021-09-01-preview"
}

#
# Storage for Audit Logs Data
#
module "idpay_audit_storage" {
  source                          = "git::https://github.com/pagopa/terraform-azurerm-v3.git//storage_account?ref=v6.15.2"
  name                            = replace("${var.domain}${var.env_short}-audit-storage", "-", "")
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = var.storage_account_replication_type
  access_tier                     = "Hot"
  blob_versioning_enabled         = var.storage_enable_versioning
  resource_group_name             = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  location                        = var.location
  advanced_threat_protection      = var.storage_advanced_threat_protection
  allow_nested_items_to_be_public = false

  blob_delete_retention_days    = var.storage_delete_retention_days
  public_network_access_enabled = var.storage_public_network_access_enabled

  tags = var.tags
}

resource "azurerm_private_endpoint" "idpay_audit_storage_private_endpoint" {

  name                = "${local.product}-audit-storage-private-endpoint"
  location            = var.location
  resource_group_name = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_dns_zone_group {
    name                 = "${local.product}-audit-storage-private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage_account.id]
  }

  private_service_connection {
    name                           = "${local.product}-audit-storage-private-service-connection"
    private_connection_resource_id = module.idpay_audit_storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

  depends_on = [
    module.idpay_audit_storage
  ]
}


# Set legal hold on container created by azure monitor with the data exporter (the name is fixed and definid by the exporter)
resource "null_resource" "idpay_audit_lh" {
  provisioner "local-exec" {
    command = <<EOC
      az storage container legal-hold set --account-name ${module.idpay_audit_storage.name} --container-name am-idpayauditlog-cl --tags idpayauditlog --allow-protected-append-writes-all true
      EOC
  }
  depends_on = [module.idpay_audit_storage, azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule]
}


resource "azurerm_log_analytics_linked_storage_account" "idpay_audit_analytics_linked_storage" {
  data_source_type      = "customlogs"
  resource_group_name   = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics.id
  storage_account_ids   = [module.idpay_audit_storage.id]
  depends_on            = [module.idpay_audit_storage]
}

resource "azurerm_log_analytics_data_export_rule" "idpay_audit_analytics_export_rule" {
  name                    = "${var.domain}${var.env_short}-audit-export-rule"
  resource_group_name     = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id   = data.azurerm_log_analytics_workspace.log_analytics.id
  destination_resource_id = module.idpay_audit_storage.id
  table_names             = ["IdPayAuditLog_CL"]
  enabled                 = true
  depends_on              = [module.idpay_audit_storage, azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage]
}

# Data Collection Endpoint
resource "azurerm_monitor_data_collection_endpoint" "idpay_audit_dce" {
  name                          = local.audit_dce_name
  resource_group_name           = data.azurerm_application_insights.application_insights.resource_group_name
  location                      = var.location
  public_network_access_enabled = true
  description                   = "audit dce"
}

# Data Collection Rule
resource "azapi_resource" "idpay_audit_dcr" {
  type      = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
  name      = local.audit_dcr_name
  parent_id = data.azurerm_resource_group.monitor_rg.id

  body = templatefile("./dcr/idpay-audit-dcr.json.tpl", {
    log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
    log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
    audit_dce_id                 = local.audit_dce_id
    audit_dcr_name               = local.audit_dcr_name
  })

  depends_on = [azurerm_monitor_data_collection_endpoint.idpay_audit_dce]
}

resource "azurerm_monitor_data_collection_rule_association" "idpay_audit_dcra" {
  for_each                = local.aks_vmss_ids
  name                    = "${local.audit_dcra_name}-${each.value}"
  target_resource_id      = each.key
  data_collection_rule_id = local.audit_dcr_id
  description             = "idpay_audit_dcra"

  depends_on = [azapi_resource.idpay_audit_dcr]
}

resource "azurerm_monitor_data_collection_rule_association" "idpay_audit_dce_association" {
  for_each                    = local.aks_vmss_ids
  target_resource_id          = each.key
  data_collection_endpoint_id = local.audit_dce_id
  description                 = "idpay_audit_dce_association"

  depends_on = [azurerm_monitor_data_collection_endpoint.idpay_audit_dce]
}

# Audit Log Table
resource "azapi_resource" "idpay_audit_log_table" {
  type      = "Microsoft.OperationalInsights/workspaces/tables@2022-10-01"
  name      = "IdPayAuditLog_CL"
  parent_id = data.azurerm_log_analytics_workspace.log_analytics.id
  body = jsonencode(
    {
      "properties" : {
        "schema" : {
          "name" : "IdPayAuditLog_CL",
          "columns" : [
            {
              "name" : "TimeGenerated",
              "type" : "datetime"
            },
            {
              "name" : "Log",
              "type" : "string"
            }
          ]
        }
      }
    }
  )
}
