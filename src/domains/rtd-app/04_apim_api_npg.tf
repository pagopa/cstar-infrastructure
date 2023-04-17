#
# New Payment Gateway PRODUCTS
#
module "npg_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v3.0.0"

  count = var.env_short == "d" ? 1 : 0

  product_id   = "ngp_api_product"
  display_name = "NPG_APP_IO_PRODUCT"
  description  = "NPG_APP_IO_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/npg/policy.xml", {})

  groups = ["developers"]
}
