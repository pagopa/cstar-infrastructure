resource "azapi_resource" "apim-merchant-id-retriever" {
  type      = "Microsoft.ApiManagement/service/policyFragments@2021-12-01-preview"
  name      = "idpay-merchant-id-retriever"
  parent_id = data.azurerm_api_management.apim_core.id

  body = jsonencode({
    properties = {
      description = "idpay-merchant-id-retriever"
      format      = "rawxml"
      value = templatefile("./api_fragment/merchant-id-retriever.xml", {
        ingress_hostname = var.ingress_load_balancer_hostname
      })
    }
  })
}
