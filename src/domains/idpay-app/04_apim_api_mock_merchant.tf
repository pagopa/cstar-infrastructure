data "azurerm_api_management_user" "idpay_apim_user_mocked_acquirer" {
  count = var.idpay_mocked_merchant_enable ? 1 : 0

  user_id             = var.idpay_mocked_acquirer_apim_user_id
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}

resource "azurerm_api_management_subscription" "idpay_apim_subscription_mocked_acquirer" {
  count = var.idpay_mocked_merchant_enable ? 1 : 0

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  user_id             = data.azurerm_api_management_user.idpay_apim_user_mocked_acquirer[0].id
  product_id          = module.idpay_api_acquirer_product.id
  display_name        = "Mocked Acquirer"
  allow_tracing       = true
  state               = "active"
}

resource "azurerm_api_management_named_value" "idpay_apim_subscription_mocked_acquirer_key" {
  count = var.idpay_mocked_merchant_enable ? 1 : 0

  name                = "mocked-acquirer-subscription-key"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "MockedAcquirerSubscriptionKey"
  value               = azurerm_api_management_subscription.idpay_apim_subscription_mocked_acquirer[0].primary_key
  secret              = true
}

#
# IDPAY PRODUCTS
#
module "idpay_api_merchant_mock_product" {
  count = var.idpay_mocked_merchant_enable ? 1 : 0

  depends_on = [azurerm_api_management_named_value.idpay_apim_subscription_mocked_acquirer_key]

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_merchant_mock_product"
  display_name = "IDPAY_MERCHANT_MOCK_PRODUCT"
  description  = "IDPAY_MERCHANT_MOCK_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = file("./api_product/acquirer/policy_mock_merchant.xml")

  groups = ["developers"]

}

#
# IDPAY API
#

## IDPAY QR-Code payment MOCK MERCHANT API ##
module "idpay_qr_code_payment_mock_merchant" {
  count = var.idpay_mocked_merchant_enable ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-qr-code-payment-mock-merchant"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY QR-CODE PAYMENT MOCK MERCHANT"
  display_name = "IDPAY QR-CODE PAYMENT MOCK MERCHANT API"
  path         = "idpay/payment/qr-code/mock/merchant"
  protocols    = ["https", "http"]

  service_url = "https://api-io.${data.azurerm_dns_zone.public.name}/idpay/payment/qr-code/merchant"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_qrcode_payment/acquirer/openapi.qrcode_payment_test_merchant.yml.tpl", {})

  xml_content = templatefile("./api/idpay_qrcode_payment/acquirer/mock_merchant_base_policy.xml", {
    origins = local.origins.base
  })

  product_ids = [module.idpay_api_merchant_mock_product[0].product_id]

}
