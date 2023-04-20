#
# New Payment Gateway PRODUCTS
#
module "npg_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v3.0.0"

  count = var.enable.api_payment_instrument ? 1 : 0

  product_id   = "ngp_api_product"
  display_name = "NPG_API_PRODUCT"
  description  = "NPG_API_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/npg/policy.xml", {})

}


## NPG Payment Instrument registrtion API ##
module "npg_payment_instrument" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v3.0.0"

  count = var.enable.api_payment_instrument ? 1 : 0

  name                = "${var.env_short}-npg-payment-instrument"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "NPG Payment Instrument registrtion"
  display_name = "NPG Payment Instrument registrtion API"

  path      = "npg/paymentinstruments"
  protocols = ["https"]

  service_url = "https://${var.ingress_load_balancer_hostname}/paymentinstruments"

  content_format = "openapi"
  content_value  = templatefile("./api/npg_payment_instrument/openapi.npg_payment_instrument.yml", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.npg_api_product[count.index].product_id]
}
