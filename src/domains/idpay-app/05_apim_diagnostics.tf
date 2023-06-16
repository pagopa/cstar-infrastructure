locals {
  idpay_apim_api_diagnostics = [
    module.idpay_onboarding_workflow_issuer.name,
    module.idpay_wallet_issuer.name,
    module.idpay_timeline_issuer.name,
    module.idpay_onboarding_workflow_io.name,
    module.idpay_wallet_io.name,
    module.idpay_timeline_io.name,
    module.idpay_iban_io.name,
    module.idpay_initiative_portal.name,
    module.idpay_group_portal.name,
    module.idpay_permission_portal.name,
    module.idpay_merchant_portal.name,
    module.idpay_notification_email_api.name,
    module.idpay_merchants_permission_portal.name,
    module.idpay_merchants_notification_email_api.name,
    module.idpay_merchants_portal.name,
    module.idpay_qr_code_payment_acquirer.name,
    module.idpay_qr_code_payment_io.name,
    module.idpay_payment_io.name,
    module.idpay_mil.name
  ]
}

resource "azurerm_api_management_api_diagnostic" "idpay_apim_api_diagnostics" {
  for_each = toset(local.idpay_apim_api_diagnostics)

  identifier               = "applicationinsights"
  resource_group_name      = data.azurerm_resource_group.apim_rg.name
  api_management_name      = data.azurerm_api_management.apim_core.name
  api_name                 = each.key
  api_management_logger_id = local.apim_logger_id

  always_log_errors = true
  verbosity         = "information"
}
