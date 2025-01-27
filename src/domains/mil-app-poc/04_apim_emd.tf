#
# EMD PRODUCTS
#

module "emd_api_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "emd_api_product"
  display_name = "EMD_PRODUCT"
  description  = "EMD_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/emd/policy_emd.xml", {
    rate_limit_emd = var.rate_limit_emd_product
    }
  )

  groups = ["developers"]
}

module "emd_mil_api_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "emd_mil_api_product"
  display_name = "EMD_MIL_PRODUCT"
  description  = "EMD_MIL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/emd/mil/policy_emd.xml", {
    rate_limit_emd = var.rate_limit_emd_product
    }
  )

  groups = ["developers"]
}

module "emd_retrieval_api_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "emd_retrieval_api_product"
  display_name = "EMD_RETRIEVAL_PRODUCT"
  description  = "EMD_RETRIEVAL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/emd/retrieval/policy_emd.xml", {
    rate_limit_emd = var.rate_limit_emd_product
    }
  )

  groups = ["developers"]
}

## EMD TPP ##
module "emd_tpp" {
  source = "./.terraform/modules/__v3__/api_management_api"


  name                = "${var.env_short}-emd-tpp"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD TPP"
  display_name = "EMD TPP API"
  path         = "emd/tpp"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdtpp/emd/tpp"

  content_format = "openapi"
  content_value  = file("./api/emd_tpp/openapi.tpp.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_api_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "save"

      xml_content = templatefile("./api/emd_tpp/post-save-tpp-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateTppDetails"

      xml_content = templatefile("./api/emd_tpp/put-update-tpp-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateTokenSection"

      xml_content = templatefile("./api/emd_tpp/put-update-token-section-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateState"

      xml_content = templatefile("./api/emd_tpp/put-update-tpp-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getTppDetails"

      xml_content = templatefile("./api/emd_tpp/get-tpp-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getTokenSection"

      xml_content = templatefile("./api/emd_tpp/get-token-section.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

## EMD CITIZEN ##
module "emd_citizen" {
  source = "./.terraform/modules/__v3__/api_management_api"


  name                = "${var.env_short}-emd-citizen"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD CITIZEN CONSENT"
  display_name = "EMD CITIZEN CONSENT API"
  path         = "emd/citizen"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdcitizen/emd/citizen"

  content_format = "openapi"
  content_value  = file("./api/emd_citizen/openapi.citizen.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_api_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "saveCitizenConsent"

      xml_content = templatefile("./api/emd_citizen/post-insert-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "stateSwitch"

      xml_content = templatefile("./api/emd_citizen/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenConsentStatus"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenConsentsList"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenConsentsListEnabled"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenEnabled"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

## EMD MESSAGE CORE ##
module "emd_message_core" {
  source = "./.terraform/modules/__v3__/api_management_api"


  name                = "${var.env_short}-emd-message-core"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD MESSAGE CORE"
  display_name = "EMD MESSAGE CORE API"
  path         = "emd/message-core"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdmessagecore/emd/message-core"

  content_format = "openapi"
  content_value  = file("./api/emd_message_core/openapi.emd.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_api_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "submitMessage"

      xml_content = templatefile("./api/emd_message_core/post-send-courtesy-message-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

## EMD PAYMENT CORE TPP##
module "emd_payment_core_tpp" {
  source = "./.terraform/modules/__v3__/api_management_api"


  name                = "${var.env_short}-emd_payment_core_tpp"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD PAYMENT CORE"
  display_name = "EMD PAYMENT CORE API"
  path         = "emd/payment"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdpaymentcore/emd/payment"

  content_format = "openapi"
  content_value  = file("./api/emd_payment_core/openapi.payment.yaml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_mil_api_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "retrievalTokens"

      xml_content = templatefile("./api/emd_payment_core/post-save-retrieval-payload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

## EMD PAYMENT CORE SEND##
module "emd_payment_core_send" {
  source = "./.terraform/modules/__v3__/api_management_api"


  name                = "${var.env_short}-emd_payment_core_send"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD PAYMENT CORE"
  display_name = "EMD PAYMENT CORE API"
  path         = "emd/payment"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdpaymentcore/emd/payment"

  content_format = "openapi"
  content_value  = file("./api/emd_payment_core/openapi.payment.yaml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_api_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getRetrieval"

      xml_content = templatefile("./api/emd_payment_core/get-retrieval-payload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}

## IDPAY MIL ONBOARDING API ##
module "emd_mil_citizen" {
  source = "./.terraform/modules/__v3__/api_management_api"


  name                = "${var.env_short}-emd-mil-citizen"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD CITIZEN OPERATION"
  display_name = "EMD CITIZEN OPERATION API"
  path         = "emd/mil/citizen"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdcitizen/emd/citizen"

  content_format = "openapi"
  content_value  = file("./api/emd_mil_citizen/openapi.mil.citizen.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_mil_api_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "saveCitizenConsent"

      xml_content = templatefile("./api/emd_mil_citizen/post-insert-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "stateSwitch"

      xml_content = templatefile("./api/emd_mil_citizen/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenConsentStatus"

      xml_content = templatefile("./api/emd_mil_citizen/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenEnabled"

      xml_content = templatefile("./api/emd_mil_citizen/get-citizen-consent-enabled-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}
