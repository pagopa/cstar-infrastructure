#
# IDPAY PRODUCTS
#

module "idpay_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_product"
  display_name = "IDPAY_API_Product"
  description  = "IDPAY_API_Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/idpay_api/policy.xml")
}

#
# IDPAY API
#

## IDPAY Onboarding workflow API ##
module "idpay_onboarding_workflow" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-onboarding-workflow"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = ""
  display_name = "IDPAY Onboarding Workflow API"
  path         = "onboarding"
  protocols    = ["https", "http"]

  service_url = "http://${var.reverse_proxy_ip}/idpayonboardingworkflow/idpay/onboarding"

  content_value = templatefile("./api/idpay_onboarding_workflow/api.idpay.onboarding.yaml.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_product.product_id]
  subscription_required = true

}
