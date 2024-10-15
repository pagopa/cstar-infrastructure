# ------------------------------------------------------------------------------
# Product.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_product" "rtp" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  product_id   = "rtp"
  display_name = "RTP Request To Pay"
  description  = "RTP Request To Pay"

  subscription_required = false
  published             = true
}

resource "azurerm_api_management_product_policy" "rtp_api_product" {

  product_id          = azurerm_api_management_product.rtp.product_id
  api_management_name = azurerm_api_management_product.rtp.api_management_name
  resource_group_name = azurerm_api_management_product.rtp.resource_group_name

  xml_content = file("./api_product/rtp/policy.xml")
}
