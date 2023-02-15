#
# Local Variables
#
locals {
  log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
  audit_dce_name      = "${var.domain}${var.env_short}-audit-dce"
  audit_dcr_name      = "${var.domain}${var.env_short}-audit-dcr"
  audit_dcra_name     = "${var.domain}${var.env_short}-audit-dcra"
  subscription_id     = data.azurerm_subscription.current.subscription_id
  resource_group_name = data.azurerm_application_insights.application_insights.resource_group_name
  audit_dce_id        = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionEndpoints/${local.audit_dce_name}"
  audit_dcr_id        = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}"
  #dcra_resource       = "/subscriptions/${local.subscription_id}/resourceGroups/MC_${var.aks_resource_group_name}_${var.aks_name}_${var.location}/providers/Microsoft.Compute/virtualMachineScaleSets"
  dcra_resource   = "/subscriptions/${local.subscription_id}/resourcegroups/${local.resource_group_name}/providers/Microsoft.ContainerService/managedClusters/${var.aks_name}"
  az_rest_api_dcr = "https://management.azure.com/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}?api-version=2021-09-01-preview"
}

#
# Storage for Audit Logs Data
#
module "idpay_audit_storage" {
  source                     = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"
  name                       = replace("${var.domain}${var.env_short}-audit-storage", "-", "")
  account_kind               = "StorageV2"
  account_tier               = "Standard"
  account_replication_type   = var.storage_account_replication_type
  access_tier                = "Hot"
  versioning_name            = "${var.domain}${var.env_short}-audit-storage-versioning"
  enable_versioning          = var.storage_enable_versioning
  resource_group_name        = data.azurerm_log_analytics_workspace.log_analytics.resource_group_name
  location                   = var.location
  advanced_threat_protection = var.storage_advanced_threat_protection
  allow_blob_public_access   = false

  blob_properties_delete_retention_policy_days = var.storage_delete_retention_days

  tags = var.tags
}

/*
# For some reason the immutable policy must be treated as an existing resource
resource "azapi_update_resource" "idpay_audit_policy" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2021-08-01"
  name      = "default"
  parent_id = module.idpay_audit_storage.resource_manager_id

  body = jsonencode({
    properties = {
      allowProtectedAppendWrites            = true
      # allowProtectedAppendWritesAll       = null
    }
  })

  depends_on = [module.idpay_audit_storage]
}
*/

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

# Data Collection Rule

resource "null_resource" "idpay_audit_dce" {
  provisioner "local-exec" {
    command = <<EOC
      az monitor data-collection endpoint create --name ${local.audit_dce_name} --resource-group ${data.azurerm_application_insights.application_insights.resource_group_name} --location ${var.location} --public-network-access Enabled
      EOC
  }
}

resource "local_file" "idpay_audit_dcr_file_tmp" {
  filename = ".terraform/tmp/idpay-audit-dcr.json"

  content = templatefile("./dcr/idpay-audit-dcr.json.tpl", {
    log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
    log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
    audit_dce_id                 = local.audit_dce_id
  })
  depends_on = [null_resource.idpay_audit_dce]
}
/*
resource "null_resource" "idpay_audit_dcr" {
  provisioner "local-exec" {
    command = <<EOC
      az monitor data-collection rule create --name ${local.audit_dcr_name} --resource-group ${data.azurerm_application_insights.application_insights.resource_group_name} --location ${var.location} --rule-file ${local_file.idpay_audit_dcr_file_tmp.filename}
      EOC
  }

  triggers = {
    data = md5(local_file.idpay_audit_dcr_file_tmp.content)
  }
  depends_on = [local_file.idpay_audit_dcr_file_tmp]
}
*/
#      {"location":"westeurope","properties":{"dataCollectionEndpointId":"${local.audit_dce_id}","streamDeclarations":{"Custom-IdPayAuditLog_CL":{"columns":[{"name":"TimeGenerated","type":"datetime"},{"name":"RawData","type":"string"}]}},"dataSources":{"logFiles":[{"name":"IdPayAuditLog_CL","streams":["Custom-IdPayAuditLog_CL"],"filePatterns":["/var/log/containers/*"],"format":"text","settings":{"text":{"recordStartTimestampFormat":\"ISO\u00208601\"}}}]},"destinations":{"logAnalytics":[{"workspaceResourceId":"${local.log_analytics_workspace_id}","name":"${local.log_analytics_workspace_name}"}]},"dataFlows":[{"streams":["Custom-IdPayAuditLog_CL"],"destinations":["${local.log_analytics_workspace_name}"],"transformKql":"source\u0020|\u0020extend\u0020Log=RawData\u0020|\u0020where\u0020Log\u0020contains\u0020\"CEF:\"","outputStream":"Custom-IdPayAuditLog_CL"}]}}

resource "null_resource" "idpay_audit_dcr" {
  provisioner "local-exec" {
    command = "az rest --url https://management.azure.com/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}?api-version=2021-09-01-preview --method PUT --body @${local_file.idpay_audit_dcr_file_tmp.filename}"
  }

  triggers = {
    data = md5(local_file.idpay_audit_dcr_file_tmp.content)
  }
  depends_on = [local_file.idpay_audit_dcr_file_tmp]
}

resource "null_resource" "idpay_audit_dcra" {
  provisioner "local-exec" {
    command = <<EOC
      az monitor data-collection rule association create --subscription ${local.subscription_id} --name ${local.audit_dcra_name} --resource ${local.dcra_resource} --rule-id ${local.audit_dcr_id}
      EOC
  }
  depends_on = [null_resource.idpay_audit_dcr]
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
