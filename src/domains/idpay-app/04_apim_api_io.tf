#
# IDPAY PRODUCTS
#
module "idpay_api_io_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_io_product"
  display_name = "IDPAY_APP_IO_PRODUCT"
  description  = "IDPAY_APP_IO_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/app_io/policy_io.xml.tpl", {
    env_short              = var.env_short
    reverse_proxy_be_io    = var.reverse_proxy_be_io
    appio_timeout_sec      = var.appio_timeout_sec
    pdv_timeout_sec        = var.pdv_timeout_sec
    pdv_tokenizer_url      = var.pdv_tokenizer_url
    pdv_retry_count        = var.pdv_retry_count
    pdv_retry_interval     = var.pdv_retry_interval
    pdv_retry_max_interval = var.pdv_retry_max_interval
    pdv_retry_delta        = var.pdv_retry_delta
  })

  groups = ["developers"]

  depends_on = [
    azurerm_api_management_named_value.pdv_api_key
  ]
}

data "azurerm_key_vault_secret" "pdv_api_key" {
  name         = "pdv-api-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_api_management_named_value" "pdv_api_key" {

  name                = format("%s-pdv-api-key", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "pdv-api-key"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.pdv_api_key.versionless_id
  }

}

#
# IDPAY API
#

## IDPAY Onboarding workflow IO API ##
module "idpay_onboarding_workflow_io" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-onboarding-workflow"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Onboarding Workflow IO"
  display_name = "IDPAY Onboarding Workflow IO API"
  path         = "idpay/onboarding"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayonboardingworkflow/idpay/onboarding"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_onboarding_workflow/openapi.onboarding.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_io_product.product_id]

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
    },
    {
      operation_id = "getInitiativeData"

      xml_content = templatefile("./api/idpay_onboarding_workflow/get-initiative-id-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Wallet IO API ##
module "idpay_wallet_io" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-wallet"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Wallet IO"
  display_name = "IDPAY Wallet IO API"
  path         = "idpay/wallet"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaywallet/idpay/wallet"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_wallet/openapi.wallet.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_io_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getWallet"
      xml_content = templatefile("./api/idpay_wallet/get-wallet-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeBeneficiaryDetail"
      xml_content = templatefile("./api/idpay_wallet/get-initiative-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getWalletDetail"
      xml_content = templatefile("./api/idpay_wallet/get-wallet-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "enrollIban"
      xml_content = templatefile("./api/idpay_wallet/put-enroll-iban-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "enrollInstrument"
      xml_content = templatefile("./api/idpay_wallet/put-enroll-instrument-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        env_short                      = var.env_short

      })
    },
    {
      operation_id = "deleteInstrument"
      xml_content = templatefile("./api/idpay_wallet/delete-instrument-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getWalletStatus"
      xml_content = templatefile("./api/idpay_wallet/get-wallet-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInstrumentList"
      xml_content = templatefile("./api/idpay_wallet/get-instrument-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "unsubscribe"

      xml_content = templatefile("./api/idpay_wallet/put-unsuscribe-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativesWithInstrument"

      xml_content = templatefile("./api/idpay_wallet/get-initiative-instrument-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    /*   ,
    {
      operation_id = "pm-mock-io"

      xml_content = templatefile("./api/idpay_wallet/get-pm-mock-io.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }*/
  ]
}

## IDPAY Timeline IO API ##
module "idpay_timeline_io" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-timeline"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Timeline IO"
  display_name = "IDPAY Timeline IO API"
  path         = "idpay/timeline"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaytimeline/idpay/timeline"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_timeline/openapi.timeline.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_io_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getTimeline"
      xml_content = templatefile("./api/idpay_timeline/get-timeline-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getTimelineDetail"
      xml_content = templatefile("./api/idpay_timeline/get-timeline-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY IBAN Wallet IO API ##
module "idpay_iban_io" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

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

## IDPAY QR-Code payment IO API ##
module "idpay_qr_code_payment_io" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-qr-code-payment-io"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY QR-CODE PAYMENT IO"
  display_name = "IDPAY QR-CODE PAYMENT IO API"
  path         = "idpay/payment/qr-code"
  protocols    = ["https", "http"]

  service_url = "https://${var.ingress_load_balancer_hostname}/idpaypayment/idpay/payment/qr-code"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_qrcode_payment/io/openapi.qrcode_payment_io.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_io_product.product_id]

}

## IDPAY Payment IO API ##
module "idpay_payment_io" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-payment-io"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY PAYMENT IO"
  display_name = "IDPAY PAYMENT IO API"
  path         = "idpay/payment"
  protocols    = ["https", "http"]

  service_url = "https://${var.ingress_load_balancer_hostname}/idpaypayment/idpay/payment"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_payment/openapi.payment.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_io_product.product_id]

}
