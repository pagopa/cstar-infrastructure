#
# CDC PRODUCTS
#

module "rtd_api_product" {
  count = var.enable.cdc.api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.42"

  product_id   = "cdc-api-product"
  display_name = "CDC_API_Product"
  description  = "Carta della Cultura API Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/cdc_api/policy.xml")
}