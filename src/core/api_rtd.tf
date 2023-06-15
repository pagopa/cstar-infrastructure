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

## RTD CSV Transaction API ##
module "rtd_csv_transaction" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  count               = var.enable.rtd.csv_transaction_apis ? 1 : 0
  name                = format("%s-rtd-csv-transaction-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API providing upload methods for csv transaction files"
  display_name = "RTD CSV Transaction API"
  path         = "rtd/csv-transaction"
  protocols    = ["https"]

  service_url = format("https://%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/rtd_csv_transaction/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createAdeSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction/create-sas-token-policy.xml", {
        blob-storage-access-key       = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = module.cstarblobstorage.name,
        blob-storage-private-fqdn     = azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
        blob-storage-container-prefix = "ade-transactions",
        rtd-ingress-ip                = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "createRtdSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction/create-sas-token-policy.xml", {
        blob-storage-access-key       = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = module.cstarblobstorage.name,
        blob-storage-private-fqdn     = azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
        blob-storage-container-prefix = "rtd-transactions",
        rtd-ingress-ip                = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "getPublicKey",
      xml_content = templatefile("./api/rtd_csv_transaction/get-public-key-policy.xml", {
        public-key-asc         = data.azurerm_key_vault_secret.cstarblobstorage_public_key[0].value,
        last-version-supported = var.batch_service_last_supported_version
      })
    },
  ]
}


resource "azurerm_api_management_api_diagnostic" "rtd_csv_transaction_diagnostic" {
  count = var.enable.rtd.csv_transaction_apis ? 1 : 0

  identifier               = "applicationinsights"
  resource_group_name      = azurerm_resource_group.rg_api.name
  api_management_name      = module.apim.name
  api_name                 = module.rtd_csv_transaction[0].name
  api_management_logger_id = module.apim.logger_id

  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "User-Agent",
      "X-Client-Certificate-End-Date"
    ]
  }
}

resource "azurerm_api_management_api_diagnostic" "blob_storage_api_diagnostic" {
  count = var.enable.rtd.csv_transaction_apis ? 1 : 0

  identifier               = "applicationinsights"
  resource_group_name      = azurerm_resource_group.rg_api.name
  api_management_name      = module.apim.name
  api_name                 = format("%s-azureblob", var.env_short)
  api_management_logger_id = module.apim.logger_id

  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 0
    headers_to_log = [
      "Content-Length"
    ]
  }
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

module "rtd_sender_mauth_check" {

  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-rtd-sender-mauth-check", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to check muthual authentication (client certificate)"
  display_name = "RTD API to Check mAuth"
  path         = "rtd/mauth"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_mauth_check/openapi.yml")

  xml_content = file("./api/rtd_sender_mauth_check/policy.xml")

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = false

  api_operation_policies = []
}

module "rtd_deposit_ade_ack" {

  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-rtd-deposit-ade-ack", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to deposit a synthetic ADE ACK file in SFTP"
  display_name = "RTD API to put AdE ACK file"
  path         = "rtd/sftp-deposit"
  protocols    = ["https"]

  service_url = format("https://cstar%ssftp.blob.core.windows.net/ade/ack/", var.env_short)

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value = templatefile("./api/rtd_deposit_ade_ack/openapi.yml", {
    host = format("https://cstar%ssftp.blob.core.windows.net/ade/ack/", var.env_short)
  })

  xml_content = file("./api/rtd_deposit_ade_ack/azureblob_policy.xml")

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_sender_auth_put_api_key" {

  count = var.enable.rtd.sender_auth ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-rtd-sender-auth-put", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "RTD API to store a new association between sender code and api key"
  display_name = "RTD API to store senderCode-apiKey"
  path         = "rtd/sender-auth"
  protocols    = ["https"]

  service_url = format("%s/rtdmssenderauth", local.ingress_load_balancer_hostname_https)

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_auth_put/openapi.yml")

  xml_content = file("./api/rtd_sender_auth_put/policy.xml")

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_filereporter" {
  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-rtd-filereporter", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to query file reporter"
  display_name = "RTD API to query file reporter"
  path         = "rtd/file-reporter"
  protocols    = ["https"]

  service_url = ""

  xml_content = file("./api/base_policy.xml")

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value = templatefile("./api/rtd_filereporter/openapi.yml", {
    host = "https://httpbin.org"
  })

  product_ids           = [data.azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getFileReport"
      xml_content = templatefile("./api/rtd_filereporter/get-file-report-policy.xml", {
        rtd-ingress = local.ingress_load_balancer_hostname_https
      })
    }
  ]
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
