#
# IDPAY PRODUCTS
#

module "idpay_api_webview_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  product_id   = "idpay_api_webview_product"
  display_name = "IDPAY_API_WEBVIEW PRODUCT"
  description  = "IDPAY_API_WEBVIEW PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/webview/policy_webview.xml", {
    rate_limit_assistance = var.rate_limit_assistance_product
    }
  )

}

#
# IDPAY API
#

## IDPAY WebView API ##

module "idpay_api_webview" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${var.env_short}-idpay-self-expense-backend"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Webview"
  display_name = "IDPAY Webview"
  path         = "idpay/self-expense"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/idpayselfexpensebackend/idpay/self-expense"

  content_format = "openapi"
  content_value  = file("./api/idpay-self-expense/openapi.self-expense.yml.tpl")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_webview_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "login"

      xml_content = templatefile("./api/idpay-self-expense/login.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRedirect"

      xml_content = templatefile("./api/idpay-self-expense/get-redirect.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "session"

      xml_content = templatefile("./api/idpay-self-expense/get-session.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

