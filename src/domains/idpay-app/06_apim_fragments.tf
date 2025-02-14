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
        pdv_timeout_sec        = var.pdv_timeout_sec
        pdv_tokenizer_url      = var.pdv_tokenizer_url
        pdv_retry_count        = var.pdv_retry_count
        pdv_retry_interval     = var.pdv_retry_interval
        pdv_retry_max_interval = var.pdv_retry_max_interval
        pdv_retry_delta        = var.pdv_retry_delta
      })
    }
  })
}

resource "azapi_resource" "apim-validate-token-mil" {
  type      = "Microsoft.ApiManagement/service/policyFragments@2021-12-01-preview"
  name      = "idpay-validate-token-mil"
  parent_id = data.azurerm_api_management.apim_core.id

  body = jsonencode({
    properties = {
      description = "idpay-validate-token-mil"
      format      = "rawxml"
      value = templatefile("./api_fragment/validate-token-mil.xml", {
        openid-config-url-mil = var.openid_config_url_mil
      })
    }
  })
}

resource "azapi_resource" "apim-webview-validate-token-mil" {
  type      = "Microsoft.ApiManagement/service/policyFragments@2021-12-01-preview"
  name      = "idpay-webview-validate-token-mil"
  parent_id = data.azurerm_api_management.apim_core.id

  body = jsonencode({
    properties = {
      description = "idpay-webview-validate-token-mil"
      format      = "rawxml"
      value = templatefile("./api_fragment/webview-validate-token-mil.xml", {
        openidUrl = var.mil_openid_url,
        issuerUrl = var.mil_issuer_url
      })
    }
  })

  lifecycle {
    ignore_changes = [body]
  }
}
