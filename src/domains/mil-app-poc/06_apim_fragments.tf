resource "azurerm_api_management_policy_fragment" "apim-validate-token-mil" {
  name              = "emd-validate-token-mil"
  api_management_id = data.azurerm_api_management.apim_core.id

  description = "emd-validate-token-mil"
  format      = "rawxml"
  value = templatefile("./api_fragment/validate-token-mil.xml", {
    openidUrl = var.mil_openid_url,
    issuerUrl = var.mil_issuer_url
  })
}
