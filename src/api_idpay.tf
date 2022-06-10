#
# IDPAY PRODUCTS
#

module "idpay_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.42"

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
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-idpay-onboarding-workflow", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = ""
  display_name = "IDPAY Onboarding Workflow API"
  path         = "idpay/onboarding"
  protocols    = ["https", "http"]

  service_url = format("http://%s/idpayonboardingworkflow/idpay/onboarding", var.reverse_proxy_ip)



  content_value = templatefile("./api/idpay_onboarding_workflow/api.idpay.onboarding.yaml.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_product.product_id]
  subscription_required = true

}
