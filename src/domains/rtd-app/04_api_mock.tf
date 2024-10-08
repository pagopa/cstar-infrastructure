module "mock_api_product" {
  source = "./.terraform/modules/__v3__/api_management_product"


  count        = var.enable.mock_io_api ? 1 : 0
  product_id   = "mock-api-product"
  display_name = "RTD_Mock_API_Product"
  description  = "RTD_Mock_API_Product"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 5

  policy_xml = file("./api_product/mock_api/policy.xml")
}

module "api_mock_io" {
  source = "./.terraform/modules/__v3__/api_management_api"

  count               = var.enable.mock_io_api ? 1 : 0
  name                = "${var.env_short}-mock-io-api"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "Mock IO API server."
  display_name = "Mock IO TEST API"
  path         = "rtd/mock-io"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_hostname_https}/cstarmockbackendio/bpd/pagopa/api/v1"

  content_format = "swagger-json"
  content_value = templatefile("./api/mock_io_test/swagger.json", {
    host = "httpbin.org"
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.mock_api_product[0].product_id]
  subscription_required = true

}
