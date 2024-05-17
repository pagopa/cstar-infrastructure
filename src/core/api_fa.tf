
module "fa_proxy_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v8.13.0"

  product_id   = "fa-proxy-product"
  display_name = "FA_PROXY_PRODUCT"
  description  = "FA_PROXY_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = templatefile("./api_product/fa_proxy/base_policy.xml", {
    bypass_cors = true
  })
}
