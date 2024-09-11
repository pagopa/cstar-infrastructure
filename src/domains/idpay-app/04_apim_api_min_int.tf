#
# IDPAY PRODUCTS
#

module "idpay_api_min_int_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "idpay_api_min_int_product"
  display_name = "IDPAY_MIN_INT_PRODUCT"
  description  = "IDPAY_MIN_INT_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/min_int/policy_min_int.xml", {
    rate_limit_minint = var.rate_limit_minint_product
    }
  )

  groups = ["developers"]
}

## IDPAY MIN INT API ##
module "idpay_min_int" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-idpay-min-int"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY MIN INT"
  display_name = "IDPAY MIN INT API"
  path         = "idpay/minint/payment"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpaypayment/idpay/minint/payment"

  content_format = "openapi"
  content_value  = file("./api/idpay_min_int/openapi.min.int.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_min_int_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "putAssociateUserTrx"

      xml_content = templatefile("./api/idpay_min_int/put-associate-user-trx-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}
