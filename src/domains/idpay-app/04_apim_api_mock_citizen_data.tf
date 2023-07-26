module "idpay_api_mock_citizen_data" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_mock_citizen_data"
  display_name = "IDPAY_APP_MOCK_CITIZEN_DATA"
  description  = "IDPAY_APP_MOCK_CITIZEN_DATA"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

   published             = false
   subscription_required = false
   approval_required     = false

   subscriptions_limit = 0

}

#
# IDPAY API
#

## IDPAY Mock citizen data ##
module "idpay_citizen_data" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-mock-citizen-data"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Mock citizen data"
  display_name = "IDPAY Mock citizen data API"
  path         = "idpay/mock/citizen"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayadmissibilityassessor/idpay/mock/citizen"

  content_format = "openapi"
  content_value  = file("./api/idpay_mock_citizen_data_api/openapi.mock.citizen.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_mock_citizen_data.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "createIsee"
      xml_content = templatefile("./api/idpay_mock_citizen_data_api/create-isee-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    }
  ]

}
