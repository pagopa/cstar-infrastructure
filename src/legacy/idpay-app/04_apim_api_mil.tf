#
# IDPAY PRODUCTS
#

module "idpay_api_mil_merchant_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "idpay_api_mil_merchant_product"
  display_name = "IDPAY_APP_MIL_MERCHANT_PRODUCT"
  description  = "IDPAY_APP_MIL_MERCHANT_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/mil_api/policy_mil_merchant.xml", {
    rate_limit_mil_merchant = var.rate_limit_mil_merchant_product
    }
  )

  groups = ["developers"]
}

module "idpay_api_mil_citizen_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "idpay_api_mil_citizen_product"
  display_name = "IDPAY_APP_MIL_CITIZEN_PRODUCT"
  description  = "IDPAY_APP_MIL_CITIZEN_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/mil_api/policy_mil_citizen.xml", {
    rate_limit_mil_citizen = var.rate_limit_mil_citizen_product
    }
  )

  groups = ["developers"]
}

## IDPAY MIL PAYMENT API ##
module "idpay_mil_payment" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-idpay-mil-payment"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIL PAYMENT"
  display_name = "IDPAY MIL PAYMENT API"
  path         = "idpay/mil/payment"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpaypayment/idpay/mil/payment"

  content_format = "openapi"
  content_value  = file("./api/idpay_mil/idpay_mil_payment/openapi.mil.payment.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_mil_merchant_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createGenericTransaction"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_payment/post-create-transaction-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getPublicKey"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_payment/get-public-key-policy.xml.tpl", {
        idpay-mil-key = azurerm_key_vault_key.idpay-mil-key.name
        keyvault-name = data.azurerm_key_vault.kv.name
      })
    },
    {
      operation_id = "getStatusTransaction"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_payment/get-transaction-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "deleteTransaction"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_payment/delete-transaction-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY MIL API ##
module "idpay_mil_merchant" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-idpay-mil-merchant"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIL MERCHANT"
  display_name = "IDPAY MIL MERCHANT API"
  path         = "idpay/mil/merchant"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpaypayment/idpay/merchant"

  content_format = "openapi"
  content_value  = file("./api/idpay_mil/idpay_mil_merchant/openapi.mil.merchant.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_mil_merchant_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getMerchantInitiativeList"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_merchant/get-merchant-initiatives-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "uploadMerchantList"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_merchant/put-merchant-upload-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}


## IDPAY MIL ONBOARDING API ##
module "idpay_mil_onboarding" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-idpay-mil-onboarding"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIL ONBOARDING"
  display_name = "IDPAY MIL ONBOARDING API"
  path         = "idpay/mil/onboarding"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpayonboardingworkflow/idpay/onboarding"

  content_format = "openapi"
  content_value  = file("./api/idpay_mil/idpay_mil_onboarding/openapi.mil.onboarding.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_mil_citizen_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "onboardingCitizen"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_onboarding/put-terms-conditions-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "checkPrerequisites"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_onboarding/put-check-prerequisites-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "onboardingStatus"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_onboarding/get-onboarding-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "consentOnboarding"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_onboarding/put-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeList"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_onboarding/get-initiative-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeBeneficiaryDetail"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_onboarding/get-initiative-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}


## IDPAY MIL WALLET API ##
module "idpay_mil_wallet" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-idpay-mil-wallet"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIL WALLET"
  display_name = "IDPAY MIL WALLET API"
  path         = "idpay/mil/wallet"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpaywallet/idpay/wallet"

  content_format = "openapi"
  content_value  = file("./api/idpay_mil/idpay_mil_wallet/openapi.mil.wallet.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_mil_citizen_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getWallet"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-wallet-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getWalletDetail"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-wallet-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "enrollIban"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/put-enroll-iban-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "enrollInstrument"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/put-enroll-instrument-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInstrumentList"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-instrument-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "deleteInstrument"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/delete-instrument-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getIdpayCodeStatus"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-code-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        env_short                      = var.env_short

      })
    },
    {
      operation_id = "generateCode"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/post-generate-idpaycode-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        env_short                      = var.env_short

      })
    },
    {
      operation_id = "enrollInstrumentCode"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/put-enroll-instrument-idpaycode-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        env_short                      = var.env_short

      })
    },
    {
      operation_id = "unsubscribe"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/put-unsubscribe-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getIban"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-iban-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getTimeline"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-timeline-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getTimelineDetail"
      xml_content = templatefile("./api/idpay_mil/idpay_mil_wallet/get-timeline-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}
