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
      operation_id = "upsert"

      xml_content = templatefile("./api/emd_tpp/post-upsert-tpp-policy.xml.tpl", {
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
      operation_id = "get"

      xml_content = templatefile("./api/emd_tpp/get-tpp-detail.xml.tpl", {
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
      operation_id = "updateState"

      xml_content = templatefile("./api/emd_citizen/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getConsentStatus"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenConsents"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getCitizenConsentsEnabled"

      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-list-policy.xml.tpl", {
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
