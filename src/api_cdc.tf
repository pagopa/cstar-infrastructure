#
# CDC PRODUCTS
#

resource "azurerm_resource_group" "rg_api_cdc" {
  name     = format("%s-api-cdc-rg", local.project)
  location = var.location

  tags = merge(var.tags, { Application = "CDC" })
}

module "cdc_api_product" {
  count = var.enable.cdc.api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.12.5"

  product_id   = "cdc-api-product"
  display_name = "CDC_API_Product"
  description  = "Carta della Cultura API Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/cdc_api/policy.xml")
}

data azurerm_key_vault_secret cdc_sogei_api_key {
  name         = "x-ibm-client-secret-sogei-cdc"
  key_vault_id = module.key_vault.id
}

resource azurerm_api_management_named_value cdc_sogei_api_key {
  name                = format("%s-x-ibm-client-secret", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "x-ibm-client-secret"
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.cdc_sogei_api_key.id
  }

}


module "api_cdc_sogei" {
  count               = var.enable.cdc.api ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.12.5"
  name                = format("%s-cdc-sogei", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API to request Carta della Cultura"
  display_name = "Request Carta della Cultura"
  path         = "sogei"
  protocols    = ["https"]

  service_url = "  https://apitest.sogei.it/interop/carta-cultura/"

  content_format = "openapi"
  content_value = templatefile("./api/cdc/openapi.sogei.yml.tpl", {
    host = "https://apitest.sogei.it/interop/carta-cultura/"
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.cdc_api_product[count.index].product_id]
  subscription_required = true

  api_operation_policies = []
}