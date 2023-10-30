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


resource "azapi_resource" "apim-pdv-tokenizer" {
  type      = "Microsoft.ApiManagement/service/policyFragments@2021-12-01-preview"
  name      = "idpay-pdv-tokenizer"
  parent_id = data.azurerm_api_management.apim_core.id

  body = jsonencode({
    properties = {
      description = "idpay-pdv-tokenizer"
      format      = "rawxml"
      value = templatefile("./api_fragment/pdv-tokenizer.xml", {
        pdv_timeout_sec   = var.pdv_timeout_sec
        pdv_tokenizer_url = var.pdv_tokenizer_url
      })
    }
  })
}
