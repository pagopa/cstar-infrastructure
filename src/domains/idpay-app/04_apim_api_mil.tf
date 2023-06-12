#
# IDPAY PRODUCTS
#

module "idpay_api_mil_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

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

}

## IDPAY MIL API ##
module "idpay_mil" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-mil"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIL"
  display_name = "IDPAY MIL API"
  path         = "idpay/mil/payment/qr-code/merchant"
  protocols    = ["https"]

  service_url = "https://api-io.${data.azurerm_dns_zone.public.name}/idpay/payment/qr-code/merchant"

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
    }
  ]

  depends_on = [
    azurerm_api_management_named_value.selc_external_api_key
  ]

}
