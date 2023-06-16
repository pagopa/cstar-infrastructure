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
resource "null_resource" "idpay_audit_dce" {
  provisioner "local-exec" {
    command = <<EOC
      az monitor data-collection endpoint create --name ${local.audit_dce_name} --resource-group ${data.azurerm_application_insights.application_insights.resource_group_name} --location ${var.location} --public-network-access Enabled
      EOC
  }
}

# Data Collection Rule
resource "local_file" "idpay_audit_dcr_file_tmp" {
  filename = ".terraform/tmp/idpay-audit-dcr.json"

  content = templatefile("./dcr/idpay-audit-dcr.json.tpl", {
    log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
    log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
    audit_dce_id                 = local.audit_dce_id
  })
  depends_on = [null_resource.idpay_audit_dce]
}

resource "null_resource" "idpay_audit_dcr" {
  provisioner "local-exec" {
    command = "az rest --url ${local.az_rest_api_dcr} --method PUT --body @${local_file.idpay_audit_dcr_file_tmp.filename}"
  }

  triggers = {
    data = md5(local_file.idpay_audit_dcr_file_tmp.content)
  }
  depends_on = [local_file.idpay_audit_dcr_file_tmp]
}

# Data Collection Rule Association
data "azurerm_virtual_machine_scale_set" "idpay_audit_resource_vmss" {
  name                = var.aks_vmss_name
  resource_group_name = "MC_${var.aks_resource_group_name}_${var.aks_name}_${var.location}"
}

resource "null_resource" "idpay_audit_dcra" {
  provisioner "local-exec" {
    command = <<EOC
      az monitor data-collection rule association create --subscription ${local.subscription_id} --name ${local.audit_dcra_name} --resource ${data.azurerm_virtual_machine_scale_set.idpay_audit_resource_vmss.id} --rule-id ${local.audit_dcr_id}
      EOC
  }
  depends_on = [null_resource.idpay_audit_dcr, data.azurerm_virtual_machine_scale_set.idpay_audit_resource_vmss]
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
