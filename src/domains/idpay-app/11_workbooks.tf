locals {
  workbooks = [
    {
      name     = "Onboarding Workflow",
      filePath = "${path.module}/workbooks/OnboardingWorkflow.json.tpl"
    },
    {
      name     = "SistemaBeneficiario",
      filePath = "${path.module}/workbooks/SistemaBeneficiario.json.tpl"
    },
    {
      name     = "SistemaPortaleEnti",
      filePath = "${path.module}/workbooks/SistemaPortaleEnti.json.tpl"
    },
    {
      name     = "EnrollmentIBAN",
      filePath = "${path.module}/workbooks/EnrollmentIBAN.json.tpl"
    },
    {
      name     = "EnrollmentInstrumentFlowIssuer",
      filePath = "${path.module}/workbooks/EnrollmentInstrumentFlowIssuer.json.tpl"
    },
    {
      name     = "PerformanceRewardNotificationExport",
      filePath = "${path.module}/workbooks/PerformanceRewardNotificationExport.json.tpl"
    },
    {
      name     = "PerformanceRewardNotificationImport",
      filePath = "${path.module}/workbooks/PerformanceRewardNotificationImport.json.tpl"
    },
    {
      name     = "PerformanceTrx",
      filePath = "${path.module}/workbooks/PerformanceTrx.json.tpl"
    },
    {
      name     = "PerformancePayment",
      filePath = "${path.module}/workbooks/PerformancePayment.json.tpl"
    },
    {
      name     = "OPEX Workbook",
      filePath = "${path.module}/workbooks/OPEXWorkbook.json.tpl"
    }
  ]
}

/* cannot use azurerm_application_insights_workbook with plugin 2.99, creating through azapi_resource.workbook_onboarding_workflow instead
resource "azurerm_application_insights_workbook" "workbook_onboarding_workflow" {
  name                = "Onboarding Workflow"
  resource_group_name = data.azurerm_resource_group.monitor_rg.name
  location            = data.azurerm_resource_group.monitor_rg.location
  display_name        = "Onboarding Workflow"
  data_json = templatefile("${path.module}/workbooks/OnboardingWorkflow.json.tpl",
    {
      subscription_id = data.azurerm_subscription.current.subscription_id
      prefix          = "${var.prefix}-${var.env_short}"
      env             = var.env
      env_short       = var.env_short
      location_short  = var.location_short
    })

  tags = var.tags
}
*/

resource "azapi_resource" "idpay_workbook" {
  for_each = {
    for index, workbook in local.workbooks :
    workbook.name => workbook
  }

  type      = "Microsoft.Insights/workbooks@2022-04-01"
  name      = uuidv5("oid", each.value.name)
  location  = data.azurerm_resource_group.monitor_rg.location
  parent_id = data.azurerm_resource_group.monitor_rg.id

  body = jsonencode({
    properties = {
      category    = "workbook"
      description = each.value.name
      displayName = each.value.name
      version     = "Notebook/1.0"
      sourceId    = "azure monitor"
      serializedData = templatefile(each.value.filePath,
        {
          subscription_id = data.azurerm_subscription.current.subscription_id
          prefix          = "${var.prefix}-${var.env_short}"
          env             = var.env
          env_short       = var.env_short
          location_short  = var.location_short
      })
    }
    kind = "shared"
  })

  tags = merge(
    var.tags,
    { "hidden-title" : each.value.name }
  )
}
