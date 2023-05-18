#
# New Payment Gateway PRODUCTS
#
resource "azurerm_api_management_product" "payment_instruments_api_product" {
  count = var.enable.api_payment_instrument ? 1 : 0

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  product_id   = "payment_instruments_api_product"
  display_name = "PAYMENT_INSTRUMENTS_API_PRODUCT"
  description  = "PAYMENT_INSTRUMENTS_API_PRODUCT"

  published             = true
  subscription_required = false
  approval_required     = false
  subscriptions_limit   = 0

}

resource "azurerm_api_management_product_policy" "payment_instruments_api_product" {
  count = var.enable.api_payment_instrument ? 1 : 0

  product_id          = azurerm_api_management_product.payment_instruments_api_product[count.index].product_id
  api_management_name = azurerm_api_management_product.payment_instruments_api_product[count.index].api_management_name
  resource_group_name = azurerm_api_management_product.payment_instruments_api_product[count.index].resource_group_name

  xml_content = file("./api_product/payment_instruments/policy.xml")
}

## Payment Instrument registration API ##
module "payment_instruments_interaction" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.3.1"

  count = var.enable.api_payment_instrument ? 1 : 0

  name                = "${var.env_short}-payment-instruments-interaction"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "Payment Instrument interaction"
  display_name = "Payment Instrument interaction API"

  path      = "paymentinstruments"
  protocols = ["https"]

  service_url = "https://${var.ingress_load_balancer_hostname}/paymentinstruments"

  content_format = "openapi"
  content_value  = file("./api/payment_instruments/openapi.payment_instruments.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids = [azurerm_api_management_product.payment_instruments_api_product[count.index].product_id]
}
