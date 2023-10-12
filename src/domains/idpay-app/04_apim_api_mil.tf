#
# IDPAY PRODUCTS
#

module "idpay_api_mil_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_mil_product"
  display_name = "IDPAY_APP_MIL_PRODUCT"
  description  = "IDPAY_APP_MIL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/mil_api/policy_mil.xml")

  groups = ["developers"]
}

## IDPAY MIL API ##
module "idpay_mil" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-mil"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIL"
  display_name = "IDPAY MIL API"
  path         = "idpay/mil/payment/qr-code/merchant"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpaypayment/idpay/payment/qr-code/merchant"

  content_format = "openapi"
  content_value  = file("./api/idpay_mil/openapi.mil.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_mil_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getMerchantInitiativeList"

      xml_content = templatefile("./api/idpay_mil/get-merchant-initiatives-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "uploadMerchantList"

      xml_content = templatefile("./api/idpay_mil/put-merchant-upload-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY MIL PAYMENT API ##
module "idpay_mil_payment" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

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

  product_ids           = [module.idpay_api_mil_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createGenericTransaction"

      xml_content = templatefile("./api/idpay_mil/idpay_mil_payment/post-create-transaction-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY MIL API ##
module "idpay_mil_merchant" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

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

  product_ids           = [module.idpay_api_mil_product.product_id]
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
