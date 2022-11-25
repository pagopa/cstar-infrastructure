## pm-admin-panel ##
module "pm_admin_panel" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-pm-admin-panel", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = ""
  display_name = "pm-admin-panel"
  path         = "backoffice"
  protocols    = ["https", "http"]

  service_url = ""

  content_format = "openapi"
  content_value = templatefile("./api/pm_admin_panel/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.wisp_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "walletv2",
      xml_content = templatefile("./api/pm_admin_panel/walletv2_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        PM-Timeout-Sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        PM-Ip-Filter-From                    = var.pm_ip_filter_range.from
        PM-Ip-Filter-To                      = var.pm_ip_filter_range.to
        CRUSCOTTO-Basic-Auth-Pwd             = data.azurerm_key_vault_secret.cruscotto-basic-auth-pwd.value
      })
    },
  ]
}

data "azurerm_key_vault" "rtd_kv" {
  name                = "${local.project}-rtd-kv"
  resource_group_name = "${local.project}-rtd-sec-rg"
}


data "azurerm_key_vault_secret" "pm_np_wallet_basic_auth" {

  count = var.enable.rtd.pm_wallet_ext_api ? 1 : 0

  name         = "pm-np-wallet-basic-auth"
  key_vault_id = data.azurerm_key_vault.rtd_kv.id
}

resource "azurerm_api_management_named_value" "pm_np_wallet_basic_auth" {
  count = var.enable.rtd.pm_wallet_ext_api ? 1 : 0

  name                = "pm-np-wallet-basic-auth"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "pm-np-wallet-basic-auth"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.pm_np_wallet_basic_auth[count.index].id
  }

}

module "pm_wallet_ext" {

  count = var.enable.rtd.pm_wallet_ext_api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.19.1"

  name                = format("%s-pm-wallet-ext", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "Access payment instruments stored in PM"
  display_name = "PM NP-Wallet External Access"
  path         = "pm/wallet-ext"
  protocols    = ["https"]

  service_url = ""

  content_format = "openapi"
  content_value = templatefile("./api/pm_wallet_ext/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.pm_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "walletv2",
      xml_content = templatefile("./api/pm_wallet_ext/walletv2_policy.xml", {
        pm-backend-url = var.pm_backend_url,
        PM-Timeout-Sec = var.pm_timeout_sec
        env_short      = var.env_short
      })
    },
  ]
}

module "wisp_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.42"

  product_id   = "wisp-api-product"
  display_name = "WISP_API_Product"
  description  = "WISP_API_Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = false
  subscription_required = true
  approval_required     = true
  subscriptions_limit   = 50

  policy_xml = file("./api_product/wisp_api/policy.xml")

}

module "pm_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.42"

  product_id   = "pm-api-product"
  display_name = "PM_API_PRODUCT"
  description  = "PM_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true
  subscriptions_limit   = 50

  policy_xml = file("./api_product/pm_api/policy.xml")
}

data "azurerm_key_vault_secret" "pagopa_platform_api_key" {
  count = var.enable.rtd.pm_integration ? 1 : 0

  name         = "pagopa-platform-apim-api-key-primary"
  key_vault_id = module.key_vault.id
}

resource "azurerm_api_management_named_value" "pagopa_platform_api_key" {
  count = var.enable.rtd.pm_integration ? 1 : 0

  name                = format("%s-pagopa-platform-api-key", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "pagopa-platform-apim-api-key-primary"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.pagopa_platform_api_key[count.index].id
  }

}