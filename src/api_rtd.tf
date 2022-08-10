#
# RTD PRODUCTS
#

module "rtd_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.42"

  product_id   = "rtd-api-product"
  display_name = "RTD_API_Product"
  description  = "RTD_API_Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/rtd_api/policy.xml")
}

module "rtd_api_product_internal" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.2.0"

  product_id   = "rtd-api-product-internal"
  display_name = "RTD_API_Product Internal"
  description  = "RTD_API_Product Internal"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 5

  policy_xml = templatefile("./api_product/rtd_api_internal/policy.xml.tpl", {
    k8s-cluster-ip-range-from = var.k8s_ip_filter_range.from
    k8s-cluster-ip-range-to   = var.k8s_ip_filter_range.to
  })
}

#
# RTD API
#

## azureblob ## 
module "api_azureblob" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-azureblob", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API to upload and download bundle of transactions"
  display_name = "Blob Storage"
  path         = "pagopastorage"
  protocols    = ["https"]

  service_url = format("https://%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/azureblob/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

## RTD Payment Instrument Manager API ##
resource "azurerm_api_management_api_version_set" "rtd_payment_instrument_manager" {
  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "RTD Payment Instrument Manager API"
  versioning_scheme   = "Segment"
}

# v1 #
module "rtd_payment_instrument_manager" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  description         = ""
  display_name        = "RTD Payment Instrument Manager API"
  path                = "rtd/payment-instrument-manager"
  protocols           = ["https", "http"]
  service_url         = format("http://%s/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager", var.reverse_proxy_ip)

  version_set_id = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id

  content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "get-hash-salt",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      operation_id = "get-hashed-pans",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy.xml.tpl", {
        # as-is due an application error in prod -->  to-be
        # host = var.env_short == "p" ? "prod.cstar.pagopa.it" : trim(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
        host = trim(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
      })
    },
  ]
}

## v2 ##
module "rtd_payment_instrument_manager_v2" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  # cause this api relies on new container, enable it when container is enabled
  count = length(azurerm_storage_container.cstar_hashed_pans) > 0 ? 1 : 0

  name                = "${var.env_short}-rtd-payment-instrument-manager-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  description         = ""
  display_name        = "RTD Payment Instrument Manager API"
  path                = "rtd/payment-instrument-manager"
  protocols           = ["https", "http"]
  service_url         = "http://${var.reverse_proxy_ip}/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager"
  version_set_id      = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id
  api_version         = "v2"

  depends_on = [module.rtd_payment_instrument_manager]

  content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "get-hash-salt",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      operation_id = "get-hashed-pans",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy-rev2.xml.tpl", {
        blob-storage-access-key       = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = module.cstarblobstorage.name,
        blob-storage-private-fqdn     = azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
        blob-storage-container-prefix = azurerm_storage_container.cstar_hashed_pans[0].name
      })
    },
  ]
}


## RTD CSV Transaction API ##
module "rtd_csv_transaction" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.1.13"

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
  content_value = templatefile("./api/rtd_csv_transaction/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
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
      xml_content = templatefile("./api/rtd_csv_transaction/get-public-key-policy.xml.tpl", {
        public-key-asc = data.azurerm_key_vault_secret.cstarblobstorage_public_key[0].value
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
      "User-Agent"
    ]
  }
}

## RTD CSV Transaction Decrypted API ##
module "rtd_blob_internal" {
  count  = var.enable.rtd.internal_api ? 1 : 0
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.2.0"

  name                = format("%s-blob-internal", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API for Internal Access to Blob Storage"
  display_name = "Blob Storage Internal"
  path         = "storage"
  protocols    = ["https"]

  service_url = format("https://%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/azureblob/internal.openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  subscription_required = true

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids = [module.rtd_api_product_internal.product_id]

  api_operation_policies = []
}

module "rtd_fake_abi_to_fiscal_code" {
  count = var.enable.tae.api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.16.0"

  name                = format("%s-rtd-fake-abi-to-fiscal-code", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to convert fake ABIs to acquirer fiscal code"
  display_name = "RTD Acquirer ABI to Fiscal Code"
  path         = "rtd/abi-to-fiscalcode"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = templatefile("./api/rtd_abi_to_fiscalcode/openapi.yml.tpl", {})

  xml_content = templatefile("./api/rtd_abi_to_fiscalcode/policy.xml.tpl", {})

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_senderadeack_filename_list" {
  count = var.enable.tae.api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.16.0"

  name                = format("%s-rtd-senderack-filename-list", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "TAE API to query file register"
  display_name = "TAE API to query file register"
  path         = "rtd/file-register"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value = templatefile("./api/rtd_senderack_filename_list/openapi.yml.tpl", {
    host = "https://httpbin.org"
  })

  xml_content = templatefile("./api/rtd_senderack_filename_list/policy.xml", {
    rtd-ingress-ip = var.reverse_proxy_ip
  })

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_sender_mauth_check" {

  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.4"

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

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = false

  api_operation_policies = []
}

module "rtd_sender_api_key_check" {

  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.4"

  name                = format("%s-rtd-sender-api-key-check", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to check RTD product API Key validity"
  display_name = "RTD API to Check API Key"
  path         = "rtd/api-key"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_api_key_check/openapi.yml")

  xml_content = file("./api/rtd_sender_api_key_check/policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_deposited_file_check" {

  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.4"

  name                = format("%s-rtd-deposited-file-check", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "RTD API to retrieve a deposited ADE file in SFTP by name"
  display_name = "RTD API to get AdE file"
  path         = "rtd/sftp-retrieve"
  protocols    = ["https"]

  service_url = format("https://cstar%ssftp.blob.core.windows.net/ade/in/", var.env_short)

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value = templatefile("./api/rtd_deposited_file_check/openapi.yml", {
    host = format("https://cstar%ssftp.blob.core.windows.net/ade/in/", var.env_short)
  })

  xml_content = file("./api/rtd_deposited_file_check/azureblob_policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_deposit_ade_ack" {

  count = var.enable.rtd.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.4"

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

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_sender_auth_put_api_key" {

  count = var.enable.rtd.sender_auth ? 1 : 0

  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.7"

  name                = format("%s-rtd-sender-auth-put", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "RTD API to store a new association between sender code and api key"
  display_name = "RTD API to store senderCode-apiKey"
  path         = "rtd/sender-auth"
  protocols    = ["https"]

  service_url = format("http://%s/rtdmssenderauth", var.reverse_proxy_ip)

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_auth_put/openapi.yml")

  xml_content = file("./api/rtd_sender_auth_put/policy.xml")

  product_ids           = [module.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
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
  product_id          = module.rtd_api_product_internal.id
  display_name        = "Internal Microservices"
  state               = "active"
  user_id             = azurerm_api_management_user.user_internal[count.index].id
  allow_tracing       = var.env_short == "d" ? true : false
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