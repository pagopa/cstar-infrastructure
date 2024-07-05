resource "azapi_resource" "apim-validate-token-mil" {
  type      = "Microsoft.ApiManagement/service/policyFragments@2021-12-01-preview"
  name      = "emd-validate-token-mil"
  parent_id = data.azurerm_api_management.apim_core.id

  body = jsonencode({
    properties = {
      description = "emd-validate-token-mil"
      format      = "rawxml"
      value = templatefile("./api_fragment/validate-token-mil.xml", {
        env = var.env_short
      })
    }
  })
}
