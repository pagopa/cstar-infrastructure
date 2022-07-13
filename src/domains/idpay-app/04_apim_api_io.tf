#
# IDPAY PRODUCTS
#
module "idpay_api_io_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_io_product"
  display_name = "IDPAY_APP_IO_PRODUCT"
  description  = "IDPAY_APP_IO_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/app_io/policy.xml.tpl", {
    env_short           = var.env_short
    reverse_proxy_be_io = var.reverse_proxy_be_io
    appio_timeout_sec   = var.appio_timeout_sec
  })

  groups = ["developers"]
}

#
# IDPAY API
#

## IDPAY Onboarding workflow IO API ##
module "idpay_onboarding_workflow_io" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-onboarding-workflow"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Onboarding Workflow IO"
  display_name = "IDPAY Onboarding Workflow IO API"
  path         = "idpay/onboarding"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayonboardingworkflow/idpay/onboarding"

  content_value = templatefile("./api/idpay_onboarding_workflow/swagger.onboarding.json.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "onboardingCitizen"
      xml_content = templatefile("./api/idpay_onboarding_workflow/put-terms-conditions-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "checkPrerequisites"
      xml_content = templatefile("./api/idpay_onboarding_workflow/put-check-prerequisites-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "onboardingStatus"
      xml_content = templatefile("./api/idpay_onboarding_workflow/get-onboarding-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "consentOnboarding"
      xml_content = templatefile("./api/idpay_onboarding_workflow/put-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Wallet IO API ##
module "idpay_wallet_io" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-wallet"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Wallet IO"
  display_name = "IDPAY Wallet IO API"
  path         = "idpay/wallet"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaywallet/idpay/wallet"

  content_value = templatefile("./api/idpay_wallet/swagger.wallet.json.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_io_product.product_id]
  subscription_required = true

}

## IDPAY Timeline IO API ##
module "idpay_timeline_io" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-timeline"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Timeline IO"
  display_name = "IDPAY Timeline IO API"
  path         = "idpay/timeline"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaytimeline/idpay/timeline"

  content_value = templatefile("./api/idpay_timeline/swagger.timeline.json.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_io_product.product_id]
  subscription_required = true

}
