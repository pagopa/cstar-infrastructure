module "mock_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

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
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  count               = var.enable.mock_io_api ? 1 : 0
  name                = format("%s-mock-io-api", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "Mock IO API server."
  display_name = "Mock IO TEST API"
  path         = "rtd/mock-io"
  protocols    = ["https"]

  service_url = "http://${var.reverse_proxy_ip_old_k8s}/cstariobackendtest/bpd/pagopa/api/v1"

  content_format = "swagger-json"
  content_value = templatefile("./api/mock_io_test/swagger.json", {
    host = "httpbin.org"
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.mock_api_product[0].product_id]
  subscription_required = true

}
