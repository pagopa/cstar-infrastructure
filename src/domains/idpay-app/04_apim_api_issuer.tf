#
# IDPAY PRODUCTS
#
module "idpay_api_issuer_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_issuer_product"
  display_name = "IDPAY_APP_ISSUER_PRODUCT"
  description  = "IDPAY_APP_ISSUER_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/app_issuer/policy_issuer.xml.tpl", {
    env_short         = var.env_short
    rtd_ingress_ip    = var.reverse_proxy_rtd
    appio_timeout_sec = var.appio_timeout_sec
    pdv_tokenizer_url = var.pdv_tokenizer_url
  })

  groups = ["developers"]

  depends_on = [
    azurerm_api_management_named_value.pdv_api_key
  ]
}

#
# IDPAY API ISSUER
#

## IDPAY Onboarding workflow ISSUER API ##
module "idpay_onboarding_workflow_issuer" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-issuer-onboarding-workflow"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Onboarding Workflow Issuer"
  display_name = "IDPAY Onboarding Workflow Issuer API"
  path         = "idpay/hb/onboarding"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayonboardingworkflow/idpay/onboarding"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_issuer_onboarding_workflow/openapi.issuer.onboarding.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_issuer_product.product_id]

  api_operation_policies = [
    {
      operation_id = "onboardingInitiativeList"
      xml_content = templatefile("./api/idpay_issuer_onboarding_workflow/get-initiativelist-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "onboardingCitizen"
      xml_content = templatefile("./api/idpay_issuer_onboarding_workflow/put-terms-conditions-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "checkPrerequisites"
      xml_content = templatefile("./api/idpay_issuer_onboarding_workflow/put-check-prerequisites-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "onboardingStatus"
      xml_content = templatefile("./api/idpay_issuer_onboarding_workflow/get-onboarding-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Wallet IO API ##
module "idpay_wallet_issuer" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-issuer-wallet"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Wallet Issuer"
  display_name = "IDPAY Wallet Issuer API"
  path         = "idpay/hb/wallet"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaywallet/idpay/wallet"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_issuer_wallet/openapi.issuer.wallet.yal.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_issuer_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getWalletDetail"
      xml_content = templatefile("./api/idpay_issuer_wallet/get-wallet-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "enrollIban"
      xml_content = templatefile("./api/idpay_issuer_wallet/put-enroll-iban-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "enrollInstrument"
      xml_content = templatefile("./api/idpay_issuer_wallet/put-enroll-instrument-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        env_short                      = var.env_short
        pm-timeout-sec                 = var.pm_timeout_sec
        pm-backend-url                 = var.pm_backend_url
      })
    },
    {
      operation_id = "getWalletStatus"
      xml_content = templatefile("./api/idpay_issuer_wallet/get-wallet-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInstrumentList"
      xml_content = templatefile("./api/idpay_issuer_wallet/get-instrument-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

## IDPAY Timeline IO API ##
module "idpay_timeline_issuer" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-issuer-timeline"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Timeline Issuer"
  display_name = "IDPAY Timeline Issuer API"
  path         = "idpay/hb/timeline"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaytimeline/idpay/timeline"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_issuer_timeline/openapi.issuer.timeline.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_issuer_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getTimelineRefund"
      xml_content = templatefile("./api/idpay_issuer_timeline/get-timeline-refund-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

/*
## IDPAY IBAN Wallet IO API ##
module "idpay_iban_io" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-iban"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY IBAN IO"
  display_name = "IDPAY IBAN IO API"
  path         = "idpay/iban"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayiban/idpay/iban"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_iban/openapi.iban.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_io_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getIban"
      xml_content = templatefile("./api/idpay_iban/get-iban-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getIbanList"
      xml_content = templatefile("./api/idpay_iban/get-iban-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}
*/
