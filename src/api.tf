resource "azurerm_resource_group" "rg_api" {
  name     = format("%s-api-rg", local.project)
  location = var.location

  tags = var.tags
}

locals {
  apim_cert_name_proxy_endpoint   = format("%s-proxy-endpoint-cert", local.project)
  portal_cert_name_proxy_endpoint = format("%s-proxy-endpoint-cert", "portal")

  api_domain        = format("api.%s.%s", var.dns_zone_prefix, var.external_domain)
  portal_domain     = format("portal.%s.%s", var.dns_zone_prefix, var.external_domain)
  management_domain = format("management.%s.%s", var.dns_zone_prefix, var.external_domain)
}


###########################
## Api Management (apim) ## 
###########################

module "apim" {

  source               = "git::https://github.com/pagopa/azurerm.git//api_management?ref=v2.2.1"
  subnet_id            = module.apim_snet.id
  location             = azurerm_resource_group.rg_api.location
  name                 = format("%s-apim", local.project)
  resource_group_name  = azurerm_resource_group.rg_api.name
  publisher_name       = var.apim_publisher_name
  publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name             = var.apim_sku
  virtual_network_type = "Internal"

  # To enable external cache uncomment the following lines
  # redis_connection_string = module.redis.primary_connection_string
  # redis_cache_id          = module.redis.id

  redis_connection_string = null
  redis_cache_id          = null

  # This enables the Username and Password Identity Provider
  sign_up_enabled = true

  sign_up_terms_of_service = {
    consent_required = false
    enabled          = false
    text             = ""
  }

  application_insights_instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key

  xml_content = templatefile("./api/base_policy.tpl", {
    portal-domain         = local.portal_domain
    management-api-domain = local.management_domain
    apim-name             = format("%s-apim", local.project)
  })

  tags = var.tags

  depends_on = [
    azurerm_application_insights.application_insights
  ]

  # Logs
  sec_log_analytics_workspace_id = var.env_short == "p" ? data.azurerm_key_vault_secret.sec_workspace_id[0].value : null
  sec_storage_id                 = var.env_short == "p" ? data.azurerm_key_vault_secret.sec_storage_id[0].value : null

}

resource "azurerm_api_management_custom_domain" "api_custom_domain" {
  api_management_id = module.apim.id

  proxy {
    host_name = local.api_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.app_gw_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.app_gw_cstar.version}",
      ""
    )
  }

  proxy {
    host_name    = trimsuffix(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
    key_vault_id = azurerm_key_vault_certificate.apim_internal_custom_domain_cert.versionless_secret_id
  }

  developer_portal {
    host_name = local.portal_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.portal_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.portal_cstar.version}",
      ""
    )
  }

  management {
    host_name = local.management_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.management_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.management_cstar.version}",
      ""
    )
  }

  depends_on = [
    azurerm_key_vault_certificate.apim_internal_custom_domain_cert
  ]
}

#########
## API ##
#########

## azureblob ## 
module "api_azureblob" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-azureblob", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "azureblob"
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

## monitor ##
module "monitor" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-monitor", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Monitor"
  display_name = "Monitor"
  path         = ""
  protocols    = ["https", "http"]

  service_url = null

  content_format = "openapi"
  content_value = templatefile("./api/monitor/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "get"
      xml_content  = file("./api/monitor/mock_policy.xml")
    }
  ]
}

## BPD Info Privacy ##
module "api_bdp_info_privacy" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-info-privacy", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD Info Privacy"
  path         = "cstar-bpd"
  protocols    = ["https", "http"]

  service_url = format("https://%s/%s",
    azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
    azurerm_storage_container.info_privacy.name
  )

  content_format = "openapi"
  content_value = templatefile("./api/bpd_info_privacy/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids           = [module.bpd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "cstarinfoprivacy"
      xml_content  = file("./api/bpd_info_privacy/cstarinfoprivacy_policy.xml")
    }
  ]
}

module "api_bpd-io_payment_instrument" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-bpd-io-payment-instrument-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD IO Payment Instrument API"
  path         = "bpd/io/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_payment_instrument/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/bpd_io_payment_instrument/policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "enrollmentPaymentInstrumentIOUsingPUT",
      xml_content = templatefile("./api/bpd_io_payment_instrument/put_enrollment_payment_instrument_io_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "paymentinstrumentsnumber",
      xml_content  = file("./api/bpd_io_payment_instrument/get_paymentinstrumentsnumber_policy.xml")
    },
  ]
}

module "api_bpd_pm_payment_instrument" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-bpd-pm-payment-instrument", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD PM Payment Instrument"
  path         = "bpd/pm/payment-instrument"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_pm_payment_instrument/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.pm_api_product.product_id]
  subscription_required = true
}

module "api_bpd_io_backend_test" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-bpd-io-backend-test-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "TEST IO Backend API server."
  display_name = "BPD IO Backend TEST API"
  path         = "bpd/pagopa/api/v1"
  protocols    = ["https", "http"]

  service_url = format("http://%s/cstariobackendtest/bpd/pagopa/api/v1", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_backend_test/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.bpd_api_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getToken",
      xml_content = templatefile("./api/bpd_io_backend_test/post_get_token_policy.xml.tpl", {
        reverse_proxy_ip = var.reverse_proxy_ip
      })
    },
  ]
}

module "api_bpd_tc" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-bpd-tc-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD TC API"
  path         = "bpd/tc"
  protocols    = ["https", "http"]

  service_url = format("https://%s/%s",
    azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
    azurerm_storage_container.bpd_terms_and_conditions.name
  )


  content_value = templatefile("./api/bpd_tc/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids = [module.bpd_api_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getTermsAndConditionsUsingGET",
      xml_content  = file("./api/bpd_tc/get_terms_and_conditions_html.xml")
    },
    {
      operation_id = "getTermsAndConditionsPDF",
      xml_content  = file("./api/bpd_tc/get_terms_and_conditions_pdf.xml")
    },
  ]
}

module "api_fa_tc" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-fa-tc-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "FA TC API"
  path         = "fa/tc"
  protocols    = ["https", "http"]

  service_url = format("https://%s/%s",
    azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
    azurerm_storage_container.fa_terms_and_conditions.name
  )


  content_value = templatefile("./api/fa_tc/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids = [module.fa_api_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getTermsAndConditionsUsingGET",
      xml_content  = file("./api/fa_tc/get_terms_and_conditions_html.xml")
    },
    {
      operation_id = "getTermsAndConditionsPDF",
      xml_content  = file("./api/fa_tc/get_terms_and_conditions_pdf.xml")
    },
  ]
}

## RTD Payment Instrument API ##
module "rtd_payment_instrument" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-rtd-payment-instrument-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "RTD Payment Instrument API"
  path         = "rtd/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/rtd_payment_instrument/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.batch_api_product.product_id]
  subscription_required = true

  api_operation_policies = []
}

## RTD Payment Instrument Manager API ##
module "rtd_payment_instrument_manager" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"

  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = ""
  display_name = "RTD Payment Instrument Manager API"
  path         = "rtd/payment-instrument-manager"
  protocols    = ["https", "http"]

  service_url = format("http://%s/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager", var.reverse_proxy_ip)



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
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans_policy.xml.tpl", {
        # as-is due an application error in prod -->  to-be
        host = var.env_short == "p" ? "prod.cstar.pagopa.it" : trim(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
      })
    },
  ]
}

## RTD CSV Transaction API ##
module "rtd_csv_transaction" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.1.13"

  count               = var.enable_rtd_csv_transaction_apis ? 1 : 0
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
      xml_content = templatefile("./api/rtd_csv_transaction/create-sas-token-policy.xml.tpl", {
        blob-storage-access-key       = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = module.cstarblobstorage.name,
        blob-storage-private-fqdn     = azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
        blob-storage-container-prefix = "ade-transactions"
      })
    },
    {
      operation_id = "createRtdSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction/create-sas-token-policy.xml.tpl", {
        blob-storage-access-key       = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = module.cstarblobstorage.name,
        blob-storage-private-fqdn     = azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
        blob-storage-container-prefix = "rtd-transactions"
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
  count = var.enable_rtd_csv_transaction_apis ? 1 : 0

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
module "rtd_csv_transaction_decrypted" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.2.0"

  count = var.enable_rtd_csv_transaction_apis ? 1 : 0

  name                = format("%s-rtd-csv-transaction-decrypted-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API providing upload methods for decrypted csv transaction files"
  display_name = "RTD CSV Transaction Decrypted API"
  path         = "rtd/csv-transaction-decrypted"
  protocols    = ["https"]

  service_url = format("https://%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn)

  content_format = "openapi"
  content_value = templatefile("./api/rtd_csv_transaction_decrypted/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.rtd_api_product_internal.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createAdeSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction_decrypted/create-sas-token-policy.xml.tpl", {
        blob-storage-access-key     = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name   = module.cstarblobstorage.name,
        blob-storage-container-name = azurerm_storage_container.ade_transactions_decrypted.name
      })
    },
    {
      operation_id = "createRtdSasToken",
      xml_content = templatefile("./api/rtd_csv_transaction_decrypted/create-sas-token-policy.xml.tpl", {
        blob-storage-access-key     = module.cstarblobstorage.primary_access_key,
        blob-storage-account-name   = module.cstarblobstorage.name,
        blob-storage-container-name = azurerm_storage_container.rtd_transactions_decrypted.name
      })
    }
  ]
}

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

# Version sets (APIs with version) #

## BPD HB Citizen API
# resource "azurerm_api_management_api_version_set" "bpd_hb_citizen" {
#   name                = format("%s-bpd-hb-citizen", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "BPD HB Citizen API"
#   versioning_scheme   = "Segment"
# }

### Original (swagger 2.0.x)
# module "bpd_hb_citizen_original" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-citizen-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_citizen.id

#   description  = "Api and Models"
#   display_name = "BPD HB Citizen API"
#   path         = "bpd/hb/citizens"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

#   content_value = templatefile("./api/bpd_hb_citizen/original/swagger.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       operation_id = "delete",
#       xml_content = templatefile("./api/bpd_hb_citizen/original/del_delete_policy.xml.tpl", {
#         reverse-proxy-ip = var.reverse_proxy_ip
#       })
#     },
#     {
#       operation_id = "enrollmentCitizenHB",
#       xml_content = templatefile("./api/bpd_hb_citizen/original/put_enrollment_citizen_hb.xml.tpl", {
#         reverse-proxy-ip = var.reverse_proxy_ip
#       })
#     },
#     {
#       operation_id = "find",
#       xml_content  = file("./api/bpd_hb_citizen/original/get_find_policy.xml")
#     },
#     {
#       operation_id = "findranking",
#       xml_content  = file("./api/bpd_hb_citizen/original/get_find_ranking.xml")
#     },
#     {
#       operation_id = "updatePaymentMethod",
#       xml_content  = file("./api/bpd_hb_citizen/original/patch_update_payment_method.xml")
#     },
#   ]
# }

# V2 (openapi 3.0.x)
# module "bpd_hb_citizen_v2" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-citizen-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_citizen.id
#   api_version         = "v2"

#   description  = "Api and Models"
#   display_name = "BPD HB Citizen API"
#   path         = "bpd/hb/citizens"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile(format("./api/bpd_hb_citizen/v2/openapi.json.tpl"), {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       operation_id = "delete",
#       xml_content = templatefile("./api/bpd_hb_citizen/v2/del_delete_policy.xml.tpl", {
#         reverse-proxy-ip = var.reverse_proxy_ip
#       })
#     },
#     {
#       operation_id = "enrollmentCitizenHB",
#       xml_content = templatefile("./api/bpd_hb_citizen/v2/put_enrollment_citizen_hb.xml.tpl", {
#         reverse-proxy-ip = var.reverse_proxy_ip
#       })
#     },
#     {
#       operation_id = "find",
#       xml_content  = file("./api/bpd_hb_citizen/v2/get_find_policy.xml")
#     },
#     {
#       operation_id = "findranking",
#       xml_content  = file("./api/bpd_hb_citizen/v2/get_find_ranking.xml")
#     },
#     {
#       operation_id = "updatePaymentMethod",
#       xml_content  = file("./api/bpd_hb_citizen/v2/patch_update_payment_method.xml")
#     },
#   ]
# }

## 02 BPD HB Payment Instruments API ##
# resource "azurerm_api_management_api_version_set" "bpd_hb_payment_instruments" {
#   name                = format("%s-bpd-hb-payment-instruments", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "BPD HB Payment Instruments API"
#   versioning_scheme   = "Segment"
# }

### Original ###
# module "bpd_hb_payment_instruments_original" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-payment-instruments-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_payment_instruments.id

#   description  = ""
#   display_name = "BPD HB Payment Instruments API"
#   path         = "bpd/hb/payment-instruments"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/bpd_hb_payment_instruments/original/openapi.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       # DEL BPay deletePaymentInstrumentHB
#       operation_id = "delbpaydeletepaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/delbpaydeletepaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # GET BPay statusPaymentInstrumentHB
#       operation_id = "getbpaystatuspaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/getbpaystatuspaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # DEL deletePaymentInstrumentHB
#       operation_id = "deldeletepaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/deldeletepaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # PUT enrollPaymentInstrumentHB
#       operation_id = "putenrollpaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#         reverse-proxy-ip                     = var.reverse_proxy_ip
#       })
#     },
#     {
#       # PUT enrollPaymentInstrumentHB BPay
#       operation_id = "putenrollpaymentinstrumenthbbpay",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbbpay_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#         reverse-proxy-ip                     = var.reverse_proxy_ip
#       })
#     },
#     {
#       # PUT enrollPaymentInstrumentHB BPay ID
#       operation_id = "putenrollpaymentinstrumenthbbpayid",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbbpayid_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#         reverse-proxy-ip                     = var.reverse_proxy_ip
#       })
#     },
#     {
#       # PUT enrollPaymentInstrumentHB Other
#       operation_id = "putenrollpaymentinstrumenthbother",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbother_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#         reverse-proxy-ip                     = var.reverse_proxy_ip
#       })
#     },
#     {
#       # PUT enrollPaymentInstrumentHB Satispay
#       operation_id = "putenrollpaymentinstrumenthbsatispay",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbsatispay_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#         reverse-proxy-ip                     = var.reverse_proxy_ip
#       })
#     },
#     {
#       # GET statusPaymentInstrumentHB
#       operation_id = "getstatuspaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/original/getstatuspaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#   ]
# }

### V2 ###
# module "bpd_hb_payment_instruments_v2" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-payment-instruments-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_payment_instruments.id
#   api_version         = "v2"

#   description  = ""
#   display_name = "BPD HB Payment Instruments API"
#   path         = "bpd/hb/payment-instruments"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/bpd_hb_payment_instruments/v2/openapi.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       # DEL BPay deletePaymentInstrumentHB
#       operation_id = "delbpaydeletepaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/delbpaydeletepaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # GET BPay statusPaymentInstrumentHB
#       operation_id = "getbpaystatuspaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/getbpaystatuspaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # DEL deletePaymentInstrumentHB
#       operation_id = "deldeletepaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/deldeletepaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # PATCH patchPaymentInstrument
#       operation_id = "patchpatchpaymentinstrument",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/patchpatchpaymentinstrument_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#     {
#       # GET statusPaymentInstrumentHB
#       operation_id = "getstatuspaymentinstrumenthb",
#       xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/getstatuspaymentinstrumenthb_policy.xml.tpl", {
#         pm-backend-url                       = var.pm_backend_url,
#         pm-timeout-sec                       = var.pm_timeout_sec
#         bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
#         env_short                            = var.env_short
#       })
#     },
#   ]
# }

## 03 BPD HB Winning Transactions API ##
# resource "azurerm_api_management_api_version_set" "bpd_hb_winning_transactions" {
#   name                = "bpd-hb-winning-transactions"
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "BPD HB Winning Transactions API"
#   versioning_scheme   = "Segment"
# }

# ### original ###
# module "bpd_hb_winning_transactions_original" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-winning-transactions-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_winning_transactions.id

#   description  = "Api and Models"
#   display_name = "BPD HB Winning Transactions API"
#   path         = "bpd/hb/winning-transactions"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

#   content_value = templatefile("./api/bpd_hb_winning_transactions/original/swagger.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       # GET getTotalCashback
#       operation_id = "getgettotalcashback",
#       xml_content = templatefile("./api/bpd_hb_winning_transactions/original/getgettotalcashback_policy.xml.tpl", {
#         reverse-proxy-ip = var.reverse_proxy_ip
#       })
#     },
#   ]
# }

# ### v2 ###
# module "bpd_hb_winning_transactions_v2" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-winning-transactions-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_winning_transactions.id
#   api_version         = "v2"

#   description  = "Api and Models"
#   display_name = "BPD HB Winning Transactions API"
#   path         = "bpd/hb/winning-transactions"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpd/hb/winning-transactions/v2", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/bpd_hb_winning_transactions/v2/openapi.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       # GET getTotalCashback
#       operation_id = "getgettotalcashback",
#       xml_content = templatefile("./api/bpd_hb_winning_transactions/v2/getgettotalcashback_policy.xml.tpl", {
#         reverse-proxy-ip = var.reverse_proxy_ip
#       })
#     },
#   ]
# }

## 04 BPD IO Award Period API ##
resource "azurerm_api_management_api_version_set" "bpd_io_award_period" {
  name                = format("%s-bpd-io-award-period", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Award Period API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_award_period_original" {
  source               = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.0.23"
  name                 = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name  = module.apim.name
  resource_group_name  = azurerm_resource_group.rg_api.name
  version_set_id       = azurerm_api_management_api_version_set.bpd_io_award_period.id
  revision             = 2
  revision_description = "closing cashback"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_award_period/original/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "findAllUsingGET"
      xml_content = templatefile("./api/bpd_io_award_period/original/findAllUsingGET_close_cashback_policy.xml.tmpl", {
        env_short = var.env_short
      })
    }
  ]
}

### v2 ###
module "bpd_io_award_period_v2" {
  source               = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.0.23"
  name                 = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name  = module.apim.name
  resource_group_name  = azurerm_resource_group.rg_api.name
  version_set_id       = azurerm_api_management_api_version_set.bpd_io_award_period.id
  revision             = 2
  revision_description = "closing cashback"
  api_version          = "v2"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_award_period/v2/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "findAllUsingGET"
      xml_content = templatefile("./api/bpd_io_award_period/v2/findAllUsingGET_close_cashback_policy.xml.tmpl", {
        env_short = var.env_short
      })
    }
  ]
}

## 05 BPD IO Citizen API ##
resource "azurerm_api_management_api_version_set" "bpd_io_citizen" {
  name                = format("%s-bpd-io-citizen", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Citizen API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_citizen_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-io-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen.id

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_citizen/original/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/bpd_io_citizen/original/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollment"
      xml_content = templatefile("./api/bpd_io_citizen/original/enrollment_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/bpd_io_citizen/original/findUsingGET_policy.xml")
    },
    {
      operation_id = "findRankingUsingGET"
      xml_content  = file("./api/bpd_io_citizen/original/findRankingUsingGET_policy.xml")
    },
    {
      operation_id = "updatePaymentMethodUsingPATCH"
      xml_content  = file("./api/bpd_io_citizen/original/updatePaymentMethodUsingPATCH_policy.xml")
    },
  ]
}

### v2 ###
module "bpd_io_citizen_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-io-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_citizen/v2/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/bpd_io_citizen/v2/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollment"
      xml_content = templatefile("./api/bpd_io_citizen/v2/enrollment_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/bpd_io_citizen/v2/findUsingGET_policy.xml")
    },
    {
      operation_id = "findRankingUsingGET"
      xml_content  = file("./api/bpd_io_citizen/v2/findRankingUsingGET_policy.xml")
    },
    {
      operation_id = "findRankingMilestoneUsingGET"
      xml_content  = file("./api/bpd_io_citizen/v2/findRankingMilestoneUsingGET_policy.xml")
    },
    {
      operation_id = "updatePaymentMethodUsingPATCH"
      xml_content  = file("./api/bpd_io_citizen/v2/updatePaymentMethodUsingPATCH_policy.xml")
    },
  ]
}

## 06 BPD HB Award Period API ##
# resource "azurerm_api_management_api_version_set" "bpd_hb_award_period" {
#   name                = format("%s-bpd-hb-award-period", var.env_short)
#   resource_group_name = azurerm_resource_group.rg_api.name
#   api_management_name = module.apim.name
#   display_name        = "BPD HB Award Period API"
#   versioning_scheme   = "Segment"
# }

# ### Original ###
# module "bdp_hb_award_period_original" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-award-period-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_award_period.id

#   description  = "Api and Models"
#   display_name = "BPD HB Award Period API"
#   path         = "bpd/hb/award-periods"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/bpd_hb_award_period/original/openapi.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       # findall
#       operation_id = "getfindall",
#       xml_content  = file("./api/bpd_hb_award_period/original/getfindall_policy.xml")
#     }
#   ]
# }

# ### v2 ###
# module "bdp_hb_award_period_v2" {
#   source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
#   name                = format("%s-bpd-hb-award-period-api", var.env_short)
#   api_management_name = module.apim.name
#   resource_group_name = azurerm_resource_group.rg_api.name
#   version_set_id      = azurerm_api_management_api_version_set.bpd_hb_award_period.id
#   api_version         = "v2"

#   description  = "Api and Models"
#   display_name = "BPD HB Award Period API"
#   path         = "bpd/hb/award-periods"
#   protocols    = ["https", "http"]

#   service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

#   content_format = "openapi"
#   content_value = templatefile("./api/bpd_hb_award_period/v2/openapi.json.tpl", {
#     host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
#   })

#   xml_content = file("./api/base_policy.xml")

#   product_ids           = [module.issuer_api_product.product_id]
#   subscription_required = true

#   api_operation_policies = [
#     {
#       # findall
#       operation_id = "getfindall",
#       xml_content  = file("./api/bpd_hb_award_period/v2/getfindall_policy.xml")
#     }
#   ]
# }

## 07 BPD IO Winning Transactions API ##
resource "azurerm_api_management_api_version_set" "bpd_io_winning_transactions" {
  name                = format("%s-bpd-io-winning-transactions", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Winning Transactions API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_winning_transactions_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-io-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_winning_transactions.id

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_winning_transactions/original/swagger.xml.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/bpd_io_winning_transactions/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getTotalScoreUsingGET"
      xml_content = templatefile("./api/bpd_io_winning_transactions/original/getTotalScoreUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

### v2 ###
module "bpd_io_winning_transactions_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-io-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_winning_transactions.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_winning_transactions/v2/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/bpd_io_winning_transactions/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "findwinningtransactionsusingget"
      xml_content  = file("./api/bpd_io_winning_transactions/v2/findwinningtransactionsusingget_policy.xml")
    },
    {
      operation_id = "getTotalScoreUsingGET"
      xml_content = templatefile("./api/bpd_io_winning_transactions/v2/getTotalScoreUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

## 08 FA IO Customer API ##
resource "azurerm_api_management_api_version_set" "fa_io_customers" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-customer", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Customer API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_customers_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-customer-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_customers[0].id

  description  = "Api and Models"
  display_name = "FA IO Customer API"
  path         = "fa/io/customer"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famscustomer/fa/customer", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_customer/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/fa_io_customer/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentUsingPUT"
      xml_content = templatefile("./api/fa_io_customer/enrollmentUsingPUT_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/fa_io_customer/findUsingGET_policy.xml.tpl")
    },
  ]
}

## 09 FA HB Customer API
resource "azurerm_api_management_api_version_set" "fa_hb_customers" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-hb-customer", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA HB Customer API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_hb_customers_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-hb-customer-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_hb_customers[0].id

  description  = "Api and Models"
  display_name = "FA HB Customer API"
  path         = "fa/hb/customer"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famscustomer/fa/customer", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_hb_customer/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/fa_hb_customer/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentUsingPUT"
      xml_content = templatefile("./api/fa_hb_customer/enrollmentUsingPUT_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/fa_hb_customer/findUsingGET_policy.xml.tpl")
    },
  ]
}

## 10 FA IO Payment Instruments API ##
resource "azurerm_api_management_api_version_set" "fa_io_payment_instruments" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-payment-instruments", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Payment Instruments API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_payment_instruments_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-payment-instruments-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_payment_instruments[0].id

  description  = ""
  display_name = "FA IO Payment Instruments API"
  path         = "fa/io/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famspaymentinstrument/fa/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_payment_instruments/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # PUT enrollPaymentInstrumentIO
      operation_id = "enrollmentUsingPUT",
      xml_content = templatefile("./api/fa_io_payment_instruments/enrollmentUsingPUT_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # DEL deletePaymentInstrumentIO
      operation_id = "deleteUsingDELETE",
      xml_content = templatefile("./api/fa_io_payment_instruments/deleteUsingDELETE_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET statusPaymentInstrumentIO
      operation_id = "findUsingGET",
      xml_content = templatefile("./api/fa_io_payment_instruments/findUsingGET_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
  ]
}

## 11 FA HB Payment Instruments API ##
resource "azurerm_api_management_api_version_set" "fa_hb_payment_instruments" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-hb-payment-instruments", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA HB Payment Instruments API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_hb_payment_instruments_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-hb-payment-instruments-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_hb_payment_instruments[0].id

  description  = ""
  display_name = "FA HB Payment Instruments API"
  path         = "fa/hb/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famspaymentinstrument/fa/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_hb_payment_instruments/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # DEL BPay deletePaymentInstrumentHB
      operation_id = "deleteUsingDELETEBpay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/deleteUsingDELETE_BPAY_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET BPay statusPaymentInstrumentHB
      operation_id = "findUsingGETBpay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/findUsingGET_BPAY_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # PUT enrollPaymentInstrumentHB
      operation_id = "enrollmentUsingPUTCard",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_Card_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB BPay
      operation_id = "enrollmentUsingPUTBpay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_BPAY_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB Other
      operation_id = "enrollmentUsingPUTOther",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_Other_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB Satispay
      operation_id = "enrollmentUsingPUTSatispay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_Satispay_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # DEL deletePaymentInstrumentHB
      operation_id = "deleteUsingDELETE",
      xml_content = templatefile("./api/fa_hb_payment_instruments/deleteUsingDELETE_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # PATCH patchPaymentInstrument
      operation_id = "patchUsingPATCH",
      xml_content = templatefile("./api/fa_hb_payment_instruments/patchUsingPATCH_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET statusPaymentInstrumentHB
      operation_id = "findUsingGET",
      xml_content = templatefile("./api/fa_hb_payment_instruments/findUsingGET_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
  ]
}

## 12 FA REGISTER Transaction API
resource "azurerm_api_management_api_version_set" "fa_register_transactions" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-register-transaction", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA REGISTER Transaction API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_register_transactions_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-register-transaction-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_register_transactions[0].id

  description  = "Api and Models"
  display_name = "FA REGISTER Transaction API"
  path         = "fa/transaction"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famstransaction/fa/transaction", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_register_transaction/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createPosTransactionUsingPOST"
      xml_content = templatefile("./api/fa_register_transaction/createPosTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "getPosTransactionUsingGET"
      xml_content = templatefile("./api/fa_register_transaction/getPosTransactionUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "getPosTransactionCustomerUsingGET"
      xml_content = templatefile("./api/fa_register_transaction/getPosTransactionCustomerUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "outcomePosTransactionUsingPOST"
      xml_content = templatefile("./api/fa_register_transaction/outcomePosTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

## 12 FA IO Transaction API
resource "azurerm_api_management_api_version_set" "fa_io_transactions" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-transaction", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Transaction API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_transactions_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-transaction-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_transactions[0].id

  description  = "Api and Models"
  display_name = "FA IO Transaction API"
  path         = "fa/io/transaction"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famstransaction/fa/transaction", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_transaction/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getTransactionListUsingGET"
      xml_content = templatefile("./api/fa_io_transaction/getTransactionListUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

## 13 FA Mock API
resource "azurerm_api_management_api_version_set" "fa_mock" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-mock", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA Mock API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_mock_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-mock-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_mock[0].id

  description  = "Api and Models"
  display_name = "FA Mock API"
  path         = "fa/mock"
  protocols    = ["https", "http"]

  service_url = format("http://%s/cstariobackendtest/fa/mock/poc", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_mock/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.fa_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "sendRegisterTransactionUsingPOST"
      xml_content = templatefile("./api/fa_mock/sendRegisterTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "sendAcquirerTransactionUsingPOST"
      xml_content = templatefile("./api/fa_mock/sendAcquirerTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "searchAcquirerTransactionErrorUsingPOST"
      xml_content = templatefile("./api/fa_mock/searchAcquirerTransactionErrorUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}

## 14 FA IO Merchant API
resource "azurerm_api_management_api_version_set" "fa_io_merchant" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-merchant", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Merchant API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_merchant_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-merchant-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_merchant[0].id

  description  = "Api and Models"
  display_name = "FA IO Merchant API"
  path         = "fa/io/merchant"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famsmerchant/fa/merchant", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_io_merchant/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "onboardingMerchantByIOUsingPut"
      xml_content = templatefile("./api/fa_io_merchant/onboardingMerchantByIOUsingPut_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}

## 14 FA EXT Merchant API
resource "azurerm_api_management_api_version_set" "fa_ext_merchant" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-ext-merchant", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA EXT Merchant API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_ext_merchant_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-ext-merchant-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_ext_merchant[0].id

  description  = "Api and Models"
  display_name = "FA EXT Merchant API"
  path         = "fa/ext/merchant"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famsmerchant/fa/merchant", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_ext_merchant/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "onboardingMerchantByProviderUsingPut"
      xml_content = templatefile("./api/fa_ext_merchant/onboardingMerchantByProviderUsingPut_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "onboardingMerchantByOtherUsingPut"
      xml_content = templatefile("./api/fa_ext_merchant/onboardingMerchantByOtherUsingPut_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "activeContractByShopIdUsingGet"
      xml_content = templatefile("./api/fa_ext_merchant/activeContractByShopIdUsingGet_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "contractListByShopIdUsingGet"
      xml_content = templatefile("./api/fa_ext_merchant/contractListByShopIdUsingGet_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}

## 14 FA EXT Provider API
resource "azurerm_api_management_api_version_set" "fa_ext_provider" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-ext-provider", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA EXT Provider API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_ext_provider_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-ext-provider-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_ext_provider[0].id

  description  = "Api and Models"
  display_name = "FA EXT Provider API"
  path         = "fa/ext/provider"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famsinvoiceprovider/fa/provider", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_ext_provider/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "providerListUsingGET"
      xml_content = templatefile("./api/fa_ext_provider/providerListUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}


##############
## Products ##
##############

module "app_io_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16"

  product_id   = "app-io-product"
  display_name = "APP_IO_PRODUCT"
  description  = "APP_IO_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = templatefile("./api_product/app_io/policy.xml.tmpl", {
    env_short         = var.env_short
    reverse_proxy_ip  = var.reverse_proxy_ip
    appio_timeout_sec = var.appio_timeout_sec
  })
}

module "batch_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16"

  product_id   = "batch-api-product"
  display_name = "BATCH_API_PRODUCT"
  description  = "BATCH_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = false
  subscription_required = true
  approval_required     = false

  policy_xml = file("./api_product/batch_api/policy.xml")
}

module "bpd_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16"

  product_id   = "bpd-api-product"
  display_name = "BPD_API_PRODUCT"
  description  = "BPD_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = file("./api_product/bpd_api/policy.xml")
}

module "issuer_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.42"

  product_id   = "issuer-api-product"
  display_name = "Issuer_API_Product"
  description  = "Issuer_API_Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/issuer_api/policy.xml")
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

module "fa_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16"

  product_id   = "fa-api-product"
  display_name = "FA_API_PRODUCT"
  description  = "FA_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = false

  policy_xml = templatefile("./api_product/fa_api/policy.xml", {
    env_short = var.env_short
  })
}
