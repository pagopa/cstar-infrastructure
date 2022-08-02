#
# IDPAY PRODUCTS
#

module "idpay_api_portal_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_portal_product"
  display_name = "IDPAY_APP_PORTAL_PRODUCT"
  description  = "IDPAY_APP_PORTAL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/portal_api/policy_portal.xml.tpl", {
    jwt_cert_signing_kv_id = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.name,
    origins                = local.origins.base
  })

}

#
# IDPAY API
#

## IDPAY Welfare Portal User Permission API ##
module "idpay_permission_portal" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-portal-permission"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Welfare Portal User Permission"
  display_name = "IDPAY Welfare Portal User Permission API"
  path         = "idpay/authorization"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackendrolepermission/idpay/welfare"

  content_format = "openapi"
  content_value  = file("./api/idpay_role_permission/openapi.permission.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "userPermission"
      xml_content = templatefile("./api/idpay_role_permission/get-permission-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "saveConsent"
      xml_content = templatefile("./api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "retrieveConsent"
      xml_content = templatefile("./api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Welfare Portal Initiative API ##
module "idpay_initiative_portal" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-initiative"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Welfare Portal Initiative"
  display_name = "IDPAY Welfare Portal Initiative API"
  path         = "idpay/initiative"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackeninitiative/idpay/initiative"

  content_format = "openapi"
  content_value  = file("./api/idpay_initiative/openapi.initiative.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getInitativeSummary"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-summary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeDetail"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "saveInitiativeGeneralInfo"

      xml_content = templatefile("./api/idpay_initiative/post-initiative-general.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeGeneralInfo"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-general.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeBeneficiary"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-beneficiary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeBeneficiaryDraft"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-beneficiary-draft.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}
