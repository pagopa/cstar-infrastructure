#
# CDC PRODUCTS
#

data "azurerm_key_vault_secret" "cdc_sogei_api_key" {
  count = var.enable.cdc.api ? 1 : 0

  name         = "x-ibm-client-secret-sogei-cdc"
  key_vault_id = module.key_vault.id
}

resource "azurerm_api_management_named_value" "cdc_sogei_api_key" {
  count = var.enable.cdc.api ? 1 : 0

  name                = format("%s-x-ibm-client-secret", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "x-ibm-client-secret"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.cdc_sogei_api_key[count.index].id
  }

  # tags = merge(var.tags, { Application = "CDC" })

}

data "azurerm_key_vault_secret" "cdc_sogei_client_id" {
  count        = var.enable.cdc.api ? 1 : 0
  name         = "x-ibm-client-id-sogei-cdc"
  key_vault_id = module.key_vault.id
}

resource "azurerm_api_management_named_value" "cdc_sogei_client_id" {
  count = var.enable.cdc.api ? 1 : 0

  name                = format("%s-x-ibm-client-id", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "x-ibm-client-id"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.cdc_sogei_client_id[count.index].id
  }

  # tags = merge(var.tags, { Application = "CDC" })

}

data "azurerm_key_vault_secret" "cdc_sogei_jwt_aud" {
  count        = var.enable.cdc.api ? 1 : 0
  name         = "jwt-aud-sogei-cdc"
  key_vault_id = module.key_vault.id
}

resource "azurerm_api_management_named_value" "cdc_sogei_jwt_aud" {
  count = var.enable.cdc.api ? 1 : 0

  name                = format("%s-jwt-aud-sogei-cdc", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "jwt-aud-sogei-cdc"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.cdc_sogei_jwt_aud[count.index].id
  }

  # tags = merge(var.tags, { Application = "CDC" })

}

data "azurerm_key_vault_certificate" "jwt_signing_cert" {
  count        = var.enable.cdc.api ? 1 : 0
  name         = "cdc-jwt"
  key_vault_id = module.key_vault.id
}

resource "azurerm_api_management_certificate" "cdc_cert_jwt" {
  count               = var.enable.cdc.api ? 1 : 0
  name                = "cdc-jwt"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  key_vault_secret_id = data.azurerm_key_vault_certificate.jwt_signing_cert[count.index].versionless_secret_id
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

  policy_xml = templatefile("./api_product/cdc_api/policy.xml.tpl", {})

  # tags = merge(var.tags, { Application = "CDC" })

  depends_on = [
    azurerm_api_management_named_value.cdc_sogei_api_key,
    azurerm_api_management_named_value.cdc_sogei_client_id
  ]

}

module "api_cdc_sogei" {
  count               = var.enable.cdc.api ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.12.5"
  name                = format("%s-cdc-sogei", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "CDC SOGEI health-check"
  display_name = "CDC SOGEI health-check"
  path         = "sogei"
  protocols    = ["https"]

  service_url = var.cdc_api_params.host

  content_format = "openapi"
  content_value = templatefile("./api/cdc/openapi.sogei.yml.tpl", {
    host = var.cdc_api_params.host
  })

  xml_content = templatefile("./api/cdc/policy.jwt.xml.tpl", {
    jwt_cert_signing_thumbprint = azurerm_api_management_certificate.cdc_cert_jwt[count.index].thumbprint,
    env_short                   = var.env_short
  })

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = []

  # tags = merge(var.tags, { Application = "CDC" })

  depends_on = [
    azurerm_api_management_named_value.cdc_sogei_api_key,
    azurerm_api_management_named_value.cdc_sogei_client_id,
    azurerm_api_management_named_value.cdc_sogei_jwt_aud,
    azurerm_api_management_certificate.cdc_cert_jwt
  ]

}

module "api_cdc_io" {
  count               = var.enable.cdc.api ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.12.5"
  name                = format("%s-cdc-io", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "CDC Richiesta Carta"
  display_name = "CDC Richiesta Carta"
  path         = "cdc"
  protocols    = ["https"]

  service_url =  var.cdc_api_params.host

  content_format = "openapi"
  content_value = templatefile("./api/cdc/openapi.io.yml.tpl", {
    host =  var.cdc_api_params.host
  })

  xml_content = templatefile("./api/cdc/policy.jwt.xml.tpl", {
    jwt_cert_signing_thumbprint = azurerm_api_management_certificate.cdc_cert_jwt[count.index].thumbprint
    env_short                   = var.env_short
  })

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = []

  # tags = merge(var.tags, { Application = "CDC" })

  depends_on = [
    azurerm_api_management_named_value.cdc_sogei_api_key,
    azurerm_api_management_named_value.cdc_sogei_client_id,
    azurerm_api_management_named_value.cdc_sogei_jwt_aud,
    azurerm_api_management_certificate.cdc_cert_jwt
  ]

}