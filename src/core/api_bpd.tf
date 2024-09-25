module "api_bpd-io_payment_instrument" {

  count = var.enable.bpd.api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"

  name                = format("%s-bpd-io-payment-instrument-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD IO Payment Instrument API"
  path         = "bpd/io/payment-instruments"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_payment_instrument/swagger.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/bpd_io_payment_instrument/policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "enrollmentPaymentInstrumentIOUsingPUT",
      xml_content = templatefile("./api/bpd_io_payment_instrument/put_enrollment_payment_instrument_io_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "paymentinstrumentsnumber",
      xml_content  = file("./api/bpd_io_payment_instrument/get_paymentinstrumentsnumber_policy.xml")
    },
  ]
}

moved {
  from = module.api_bpd-io_payment_instrument
  to   = module.api_bpd-io_payment_instrument[0]
}

module "api_bpd_pm_payment_instrument" {

  count = var.enable.bpd.api_pm ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"

  name                = format("%s-bpd-pm-payment-instrument", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD PM Payment Instrument"
  path         = "bpd/pm/payment-instrument"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_pm_payment_instrument/openapi.json", {
    host = local.apim_hostname # azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  # mock delete api only for dev and uat
  api_operation_policies = [
    {
      operation_id = "delete"
      xml_content  = file("./api/bpd_pm_payment_instrument/mock_delete_policy.xml")
    }
  ]

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.pm_api_product.product_id]
  subscription_required = true
}


moved {
  from = module.api_bpd_pm_payment_instrument
  to   = module.api_bpd_pm_payment_instrument[0]
}

##############
## Products ##
##############
module "bpd_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v8.13.0"

  product_id   = "bpd-api-product"
  display_name = "BPD_API_PRODUCT"
  description  = "BPD_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = file("./api_product/bpd_api/policy.xml")
}

module "issuer_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v8.13.0"

  product_id   = "issuer-api-product"
  display_name = "Issuer_API_Product"
  description  = "Issuer_API_Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/issuer_api/policy.xml")
}
