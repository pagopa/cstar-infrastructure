## IDPAY Mock citizen data ##
module "idpay_citizen_data" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  count               = var.enable.mock_io_api ? 1 : 0
  name                = "${var.env_short}-idpay-mock-citizen-data"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Mock citizen data"
  display_name = "IDPAY Mock citizen data API"
  path         = "idpay/mock/citizen"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayadmissibility/idpay/mock/citizen"

  content_format = "openapi"
  content_value  = file("./api/idpay_mock_citizen_data/openapi.mock.citizen.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [data.azurerm_api_management_product.mock_api_product[0].product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createIsee"
      xml_content = templatefile("./api/idpay_mock_citizen_data/create-isee-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    }
  ]

}
