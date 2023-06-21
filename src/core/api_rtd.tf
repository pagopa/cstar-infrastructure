#
# RTD PRODUCTS
#

data "azurerm_api_management_product" "rtd_api_product" {
  product_id          = "rtd-api-product"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
}

data "azurerm_api_management_product" "rtd_api_product_internal" {
  product_id          = "rtd-api-product-internal"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
}

#
# RTD API
#

## azureblob ##
module "api_azureblob" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-azureblob", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API to upload and download bundle of transactions"
  display_name = "Blob Storage"
  path         = "pagopastorage"
  protocols    = ["https"]

  service_url = format("https://%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/azureblob/openapi.json", {
    host                = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
    pgp-put-limit-bytes = var.pgp_put_limit_bytes
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "putblob",
      xml_content = templatefile("./api/azureblob/azureblob_authorizative_policy.xml", {
        rtd-ingress         = local.ingress_load_balancer_hostname_https,
        pgp-put-limit-bytes = var.pgp_put_limit_bytes
      })
    }
  ]
}

## RTD Payment Instrument Manager API ##
data "azurerm_api_management_api_version_set" "rtd_payment_instrument_manager" {
  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
}


## RTD Payment Manager Token API ##
data "azurerm_key_vault_secret" "pagopa_platform_api_tkm_key" {
  count = var.enable.rtd.tkm_integration ? 1 : 0

  name         = "pagopa-platform-apim-api-key-primary-tkm"
  key_vault_id = data.azurerm_key_vault.rtd_domain_kv.id
}

resource "azurerm_api_management_named_value" "pagopa_platform_api_primary_key_tkm" {
  count = var.enable.rtd.tkm_integration ? 1 : 0

  name                = "pagopa-platform-apim-api-key-primary-tkm"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name

  display_name = "pagopa-platform-apim-api-key-primary-tkm"
  secret       = true

  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.pagopa_platform_api_tkm_key[count.index].id
  }
}

module "rtd_payment_instrument_token_api" {
  count  = var.enable.rtd.tkm_integration ? 1 : 0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-payment-instrument-manager-token-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API providing upload methods for tokens files"
  display_name = "RTD Token Manager API"
  path         = "rtd/token"
  protocols    = ["https"]

  service_url = ""

  content_format = "openapi"
  content_value = templatefile("./api/rtd_payment_instrument_token/openapi.yml", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getTokenListPublicPGPKey",
      xml_content = templatefile("./api/rtd_payment_instrument_token/get-token-public-key-policy.xml", {
        pagopa-platform-url     = var.pagopa_platform_url,
        pm-timeout-seconds      = var.pm_timeout_sec,
        pagopa-platform-api-key = azurerm_api_management_named_value.pagopa_platform_api_primary_key_tkm[count.index].name
      })
    },
    {
      operation_id = "uploadAcquirerTokenFile",
      xml_content = templatefile("./api/rtd_payment_instrument_token/upload-token-file-policy.xml", {
        pagopa-platform-url     = var.pagopa_platform_url,
        pagopa-platform-api-key = azurerm_api_management_named_value.pagopa_platform_api_primary_key_tkm[count.index].name
      })
    },
    {
      operation_id = "getKnownHashes",
      xml_content = templatefile("./api/rtd_payment_instrument_token/get-known-hashes-policy.xml", {
        pagopa-platform-url     = var.pagopa_platform_url,
        pm-timeout-seconds      = var.pm_timeout_sec,
        pagopa-platform-api-key = azurerm_api_management_named_value.pagopa_platform_api_primary_key_tkm[count.index].name
      })
    },
    {
      operation_id = "getBinRangeLink",
      xml_content = templatefile("./api/rtd_payment_instrument_token/get-bin-range-policy.xml", {
        pagopa-platform-url     = var.pagopa_platform_url,
        pm-timeout-seconds      = var.pm_timeout_sec,
        pagopa-platform-api-key = azurerm_api_management_named_value.pagopa_platform_api_primary_key_tkm[count.index].name
      })
    }
  ]

  depends_on = [azurerm_api_management_named_value.pagopa_platform_api_primary_key_tkm[0]]
}

## RTD CSV Transaction Decrypted API ##
module "rtd_blob_internal" {
  count  = var.enable.rtd.internal_api ? 1 : 0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-blob-internal", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API for Internal Access to Blob Storage"
  display_name = "Blob Storage Internal"
  path         = "storage"
  protocols    = ["https"]

  service_url = format("https://%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/azureblob/internal.openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name,

  })

  subscription_required = true

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids = [data.azurerm_api_management_product.rtd_api_product_internal.product_id]

  api_operation_policies = []
}

module "rtd_fake_abi_to_fiscal_code" {
  count = var.enable.tae.api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = "${var.env_short}-rtd-fake-abi-to-fiscal-code"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to convert fake ABIs to acquirer fiscal code"
  display_name = "RTD Acquirer ABI to Fiscal Code"
  path         = "rtd/abi-to-fiscalcode"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = templatefile("./api/rtd_abi_to_fiscalcode/openapi.yml", {})

  xml_content = templatefile("./api/rtd_abi_to_fiscalcode/policy.xml", {})

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}
locals {
  rtd_senderack_download_file_uri = format("https://%s/%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn, "sender-ade-ack") //azurerm_storage_container.sender_ade_ack[0].name
}

#
# SUBSCRIPTIONS FOR INTERNAL USERS
#
resource "random_password" "rtd_internal_sub_key" {
  count       = var.enable.rtd.internal_api ? 1 : 0
  length      = 32
  special     = false
  upper       = false
  min_numeric = 5
  keepers = {
    version = 1
    date    = "2022-02-22"
  }
}

resource "random_password" "apim_internal_user_id" {
  count       = var.enable.rtd.internal_api ? 1 : 0
  length      = 32
  special     = false
  upper       = false
  min_numeric = 5
  keepers = {
    version = 1
    date    = "2022-03-02"
  }
}

resource "azurerm_api_management_user" "user_internal" {
  count               = var.enable.rtd.internal_api ? 1 : 0
  user_id             = random_password.apim_internal_user_id[count.index].result
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  first_name          = "User"
  last_name           = "Internal"
  email               = data.azurerm_key_vault_secret.apim_internal_user_email.value
  state               = "active"
}

resource "azurerm_api_management_subscription" "rtd_internal" {
  count               = var.enable.rtd.internal_api ? 1 : 0
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  product_id          = data.azurerm_api_management_product.rtd_api_product_internal.id
  display_name        = "Internal Microservices"
  state               = "active"
  user_id             = azurerm_api_management_user.user_internal[count.index].id
  allow_tracing       = false
  primary_key         = random_password.rtd_internal_sub_key[count.index].result
}

resource "azurerm_key_vault_secret" "rtd_internal_api_product_subscription_key" {
  count        = var.enable.rtd.internal_api ? 1 : 0
  name         = "rtd-internal-api-product-subscription-key"
  value        = random_password.rtd_internal_sub_key[count.index].result
  content_type = "string"
  key_vault_id = module.key_vault.id

  depends_on = [
    # create subscription, then store the key
    azurerm_api_management_subscription.rtd_internal
  ]
}
