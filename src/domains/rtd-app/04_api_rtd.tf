## RTD Payment Manager API ##
resource "azurerm_api_management_product" "rtd_api_product" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  product_id   = "rtd-api-product"
  display_name = "RTD_API_Product"
  description  = "RTD_API_Product"

  subscription_required = true
  subscriptions_limit   = 50
  approval_required     = true
  published             = true

}

resource "azurerm_api_management_product_policy" "rtd_api_product" {

  product_id          = azurerm_api_management_product.rtd_api_product.product_id
  api_management_name = azurerm_api_management_product.rtd_api_product.api_management_name
  resource_group_name = azurerm_api_management_product.rtd_api_product.resource_group_name

  xml_content = file("./api_product/rtd_api/policy.xml")
}

resource "azurerm_api_management_product" "rtd_api_product_internal" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  product_id   = "rtd-api-product-internal"
  display_name = "RTD_API_Product Internal"
  description  = "RTD_API_Product Internal"

  subscription_required = true
  subscriptions_limit   = 5
  approval_required     = true
  published             = true

}

resource "azurerm_api_management_product_policy" "rtd_api_product_internal" {

  product_id          = azurerm_api_management_product.rtd_api_product_internal.product_id
  api_management_name = azurerm_api_management_product.rtd_api_product_internal.api_management_name
  resource_group_name = azurerm_api_management_product.rtd_api_product_internal.resource_group_name

  xml_content = templatefile("./api_product/rtd_api_internal/policy.xml", {
    k8s-cluster-ip-range-from     = var.k8s_ip_filter_range.from
    k8s-cluster-ip-range-to       = var.k8s_ip_filter_range.to
    k8s-cluster-aks-ip-range-from = var.k8s_ip_filter_range_aks.from
    k8s-cluster-aks-ip-range-to   = var.k8s_ip_filter_range_aks.to
  })
}


## RTD Payment Manager API ##
resource "azurerm_api_management_api_version_set" "rtd_payment_instrument_manager" {
  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  api_management_name = data.azurerm_api_management.apim_core.name
  display_name        = "RTD Payment Instrument Manager API"
  versioning_scheme   = "Segment"
}

# v1 #
resource "azurerm_api_management_api" "rtd_payment_instrument_manager" {
  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = ""
  display_name = "RTD Payment Instrument Manager API"
  path         = "rtd/payment-instrument-manager"

  version_set_id = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id

  revision              = "1"
  subscription_required = true
  protocols             = ["https", "http"]

  service_url = format("http://%s/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager", var.reverse_proxy_ip_old_k8s)

  import {
    content_format = "swagger-json"
    content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml", {
      host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
    })
  }

}

resource "azurerm_api_management_api_policy" "rtd_payment_instrument_manager" {
  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager.name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager.api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager.resource_group_name

  xml_content = file("./api/base_policy.xml")
}


resource "azurerm_api_management_product_api" "rtd_payment_instrument_manager" {
  product_id          = azurerm_api_management_product.rtd_api_product.product_id
  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager.name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager.api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager.resource_group_name
}

resource "azurerm_api_management_api_operation_policy" "get_hash_salt_policy" {
  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager.name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager.api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager.resource_group_name
  operation_id        = "get-hash-salt"

  xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml", {
    pm-backend-url                       = var.pm_backend_url,
    rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
    mock_response                        = var.env_short == "d" || var.env_short == "u" || var.env_short == "p"
    pagopa-platform-api-key-name         = "pagopa-platform-apim-api-key-primary"
  })
}


resource "azurerm_api_management_api_operation_policy" "get_hashed_pans_policy" {
  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager.name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager.api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager.resource_group_name
  operation_id        = "get-hashed-pans"

  xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy.xml", {
    # as-is due an application error in prod -->  to-be
    # host = var.env_short == "p" ? "prod.cstar.pagopa.it" : trim(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
    host = trim(data.azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
  })
}

# v2
resource "azurerm_api_management_api" "rtd_payment_instrument_manager_v2" {
  count = var.enable.hashed_pans_container ? 1 : 0

  name                = "${var.env_short}-rtd-payment-instrument-manager-api-v2"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = ""
  display_name = "RTD Payment Instrument Manager API"
  path         = "rtd/payment-instrument-manager"

  version_set_id        = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id
  version               = "v2"
  revision              = "1"
  subscription_required = true
  protocols             = ["https", "http"]

  service_url = "http://${var.reverse_proxy_ip_old_k8s}/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager"

  import {
    content_format = "swagger-json"
    content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml", {
      host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
    })
  }

}

resource "azurerm_api_management_api_policy" "rtd_payment_instrument_manager_v2" {
  count = var.enable.hashed_pans_container ? 1 : 0

  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].resource_group_name

  xml_content = file("./api/base_policy.xml")
}


resource "azurerm_api_management_product_api" "rtd_payment_instrument_manager_v2" {
  count = var.enable.hashed_pans_container ? 1 : 0

  product_id          = azurerm_api_management_product.rtd_api_product.product_id
  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].resource_group_name
}

resource "azurerm_api_management_api_operation_policy" "get_hash_salt_policy_v2" {
  count = var.enable.hashed_pans_container ? 1 : 0

  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].resource_group_name
  operation_id        = "get-hash-salt"

  xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml", {
    pm-backend-url                       = var.pagopa_platform_url,
    rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
    mock_response                        = var.env_short == "d" || var.env_short == "u" || var.env_short == "p"
    pagopa-platform-api-key-name         = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
  })
}


resource "azurerm_api_management_api_operation_policy" "get_hashed_pans_policy_v2" {
  count = var.enable.hashed_pans_container ? 1 : 0

  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v2[0].resource_group_name
  operation_id        = "get-hashed-pans"

  xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy-rev2.xml", {
    blob-storage-access-key       = data.azurerm_storage_account.cstarblobstorage.primary_access_key,
    blob-storage-account-name     = data.azurerm_storage_account.cstarblobstorage.name,
    blob-storage-private-fqdn     = local.cstarblobstorage_private_fqdn,
    blob-storage-container-prefix = azurerm_storage_container.cstar_hashed_pans[0].name
  })
}

resource "azurerm_api_management_api" "rtd_payment_instrument_manager_v3" {
  count = var.enable.hashed_pans_container ? 1 : 0

  name                = "${var.env_short}-rtd-payment-instrument-manager-api-v3"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = ""
  display_name = "RTD Payment Instrument Manager API"
  path         = "rtd/payment-instrument-manager"

  version_set_id        = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id
  version               = "v3"
  revision              = "1"
  subscription_required = true
  protocols             = ["https", "http"]

  service_url = "http://${var.reverse_proxy_ip_old_k8s}/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager"

  import {
    content_format = "swagger-json"
    content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml", {
      host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
    })
  }

}

resource "azurerm_api_management_api_policy" "rtd_payment_instrument_manager_v3" {
  count = var.enable.hashed_pans_container ? 1 : 0

  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].resource_group_name

  xml_content = file("./api/base_policy.xml")
}


resource "azurerm_api_management_product_api" "rtd_payment_instrument_manager_v3" {
  count = var.enable.hashed_pans_container ? 1 : 0

  product_id          = azurerm_api_management_product.rtd_api_product.product_id
  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].resource_group_name
}

resource "azurerm_api_management_api_operation_policy" "get_hash_salt_policy_v3" {
  count = var.enable.hashed_pans_container ? 1 : 0

  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].resource_group_name
  operation_id        = "get-hash-salt"

  xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml", {
    pm-backend-url                       = var.pm_backend_url,
    rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
    mock_response                        = false
    pagopa-platform-api-key-name         = "pagopa-platform-apim-api-key-primary"
  })
}


resource "azurerm_api_management_api_operation_policy" "get_hashed_pans_policy_v3" {
  count = var.enable.hashed_pans_container ? 1 : 0

  api_name            = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].name
  api_management_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].api_management_name
  resource_group_name = azurerm_api_management_api.rtd_payment_instrument_manager_v3[0].resource_group_name
  operation_id        = "get-hashed-pans"

  xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy-rev3.xml", {
    blob-storage-private-fqdn     = local.cstarblobstorage_private_fqdn,
    blob-storage-container-prefix = azurerm_storage_container.cstar_hashed_pans_par[0].name
  })
}

module "rtd_sender_api_key_check" {
  count = var.enable.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = format("%s-rtd-sender-api-key-check", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name


  description  = "RTD API to check RTD product API Key validity"
  display_name = "RTD API to Check API Key"
  path         = "rtd/api-key"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_api_key_check/openapi.yml")

  xml_content = file("./api/rtd_sender_api_key_check/policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_deposited_file_check" {
  count = var.enable.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = format("%s-rtd-deposited-file-check", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name


  description  = "RTD API to retrieve a deposited ADE file in SFTP by name"
  display_name = "RTD API to get AdE file"
  path         = "rtd/sftp-retrieve"
  protocols    = ["https"]

  service_url = "https://cstar${var.env_short}blobstorage.blob.core.windows.net/ade-integration-aggregates/"

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_deposited_file_check/openapi.yml")

  xml_content = file("./api/rtd_deposited_file_check/azureblob_policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_senderadeack_filename_list" {
  count = var.enable.tae_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = format("%s-rtd-senderack-filename-list", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name


  description  = "TAE API to query file register"
  display_name = "TAE API to query file register"
  path         = "rtd/file-register"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value = templatefile("./api/rtd_senderack_filename_list/openapi.yml", {
    host = "https://httpbin.org"
  })

  xml_content = templatefile("./api/rtd_senderack_filename_list/policy.xml", {
    rtd-ingress = local.ingress_load_balancer_hostname_https
  })

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}


## RTD Payment Instrument API ##
module "rtd_payment_instrument" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"
  name                = format("%s-rtd-payment-instrument-api", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = ""
  display_name = "RTD Payment Instrument API"
  path         = "rtd/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip_old_k8s)

  content_format = "openapi"
  content_value = templatefile("./api/rtd_payment_instrument/openapi.json", {
    host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.batch_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "batch_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "batch-api-product"
  display_name = "BATCH_API_PRODUCT"
  description  = "BATCH_API_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = true
  approval_required     = false

  policy_xml = file("./api_product/batch_api/policy.xml")
}

module "rtd_sender_auth_put_api_key" {

  count = var.enable.sender_auth ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = format("%s-rtd-sender-auth-put", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "RTD API to store a new association between sender code and api key"
  display_name = "RTD API to store senderCode-apiKey"
  path         = "rtd/sender-auth"
  protocols    = ["https"]

  service_url = format("%s/rtdmssenderauth", local.ingress_load_balancer_hostname_https)

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_auth_put/openapi.yml")

  xml_content = file("./api/rtd_sender_auth_put/policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}


resource "azurerm_api_management_api_diagnostic" "rtd_csv_transaction_diagnostic" {
  count = var.enable.csv_transaction_apis ? 1 : 0

  identifier               = "applicationinsights"
  api_management_name      = data.azurerm_api_management.apim_core.name
  resource_group_name      = data.azurerm_resource_group.apim_rg.name
  api_name                 = module.rtd_csv_transaction[0].name
  api_management_logger_id = local.apim_logger_id


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
  count = var.enable.csv_transaction_apis ? 1 : 0

  identifier               = "applicationinsights"
  api_management_name      = data.azurerm_api_management.apim_core.name
  resource_group_name      = data.azurerm_resource_group.apim_rg.name
  api_name                 = format("%s-azureblob", var.env_short)
  api_management_logger_id = local.apim_logger_id

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


## RTD CSV Transaction API ##
module "rtd_csv_transaction" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  count               = var.enable.csv_transaction_apis ? 1 : 0
  name                = format("%s-rtd-csv-transaction-api", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "API providing upload methods for csv transaction files"
  display_name = "RTD CSV Transaction API"
  path         = "rtd/csv-transaction"
  protocols    = ["https"]

  service_url = format("https://%s", local.cstarblobstorage_private_fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/rtd_csv_transaction/openapi.json", {
    host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createAdeSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction/create-sas-token-policy.xml", {
        blob-storage-access-key       = data.azurerm_storage_account.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = data.azurerm_storage_account.cstarblobstorage.name,
        blob-storage-private-fqdn     = local.cstarblobstorage_private_fqdn,
        blob-storage-container-prefix = "ade-transactions",
        rtd-ingress-ip                = var.reverse_proxy_ip_old_k8s
      })
    },
    {
      operation_id = "createRtdSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction/create-sas-token-policy.xml", {
        blob-storage-access-key       = data.azurerm_storage_account.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = data.azurerm_storage_account.cstarblobstorage.name,
        blob-storage-private-fqdn     = local.cstarblobstorage_private_fqdn,
        blob-storage-container-prefix = "rtd-transactions",
        rtd-ingress-ip                = var.reverse_proxy_ip_old_k8s
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

module "rtd_sender_mauth_check" {

  count = var.enable.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-rtd-sender-mauth-check", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name


  description  = "RTD API to check muthual authentication (client certificate)"
  display_name = "RTD API to Check mAuth"
  path         = "rtd/mauth"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value  = file("./api/rtd_sender_mauth_check/openapi.yml")

  xml_content = file("./api/rtd_sender_mauth_check/policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = false

  api_operation_policies = []
}

module "rtd_deposit_ade_ack" {

  count = var.enable.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = format("%s-rtd-deposit-ade-ack", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name


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

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

module "rtd_filereporter" {
  count = var.enable.batch_service_api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = format("%s-rtd-filereporter", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name


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

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
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
