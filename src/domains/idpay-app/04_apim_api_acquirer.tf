#
# IDPAY PRODUCTS
#
module "idpay_api_acquirer_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_acquirer_product"
  display_name = "IDPAY_ACQUIRER_PRODUCT"
  description  = "IDPAY_ACQUIRER_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/acquirer/policy_acquirer.xml.tpl", {
    env_short              = var.env_short
    reverse_proxy_be_io    = var.reverse_proxy_be_io
    appio_timeout_sec      = var.appio_timeout_sec
    pdv_timeout_sec        = var.pdv_timeout_sec
    pdv_tokenizer_url      = var.pdv_tokenizer_url
    pdv_retry_count        = var.pdv_retry_count
    pdv_retry_interval     = var.pdv_retry_interval
    pdv_retry_max_interval = var.pdv_retry_max_interval
    pdv_retry_delta        = var.pdv_retry_delta
  })

  groups = ["developers"]

}

#
# IDPAY API
#

## IDPAY QR-Code payment ACQUIRER API ##
module "idpay_qr_code_payment_acquirer" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-qr-code-payment-acquirer"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY QR-CODE PAYMENT ACQUIRER"
  display_name = "IDPAY QR-CODE PAYMENT ACQUIRER API"
  path         = "idpay/payment/qr-code/merchant"
  protocols    = ["https", "http"]

  service_url = "https://${var.ingress_load_balancer_hostname}/idpaypayment/idpay/payment/qr-code/merchant"

  content_format = "openapi"
  content_value  = templatefile("./api/idpay_qrcode_payment/acquirer/openapi.qrcode_payment_acquirer.yml.tpl", {})

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.idpay_api_acquirer_product.product_id]

}
