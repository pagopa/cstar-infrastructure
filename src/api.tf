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

  source                  = "git::https://github.com/pagopa/azurerm.git//api_management?ref=v1.0.58"
  subnet_id               = module.apim_snet.id
  location                = azurerm_resource_group.rg_api.location
  name                    = format("%s-apim", local.project)
  resource_group_name     = azurerm_resource_group.rg_api.name
  publisher_name          = var.apim_publisher_name
  publisher_email         = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name                = var.apim_sku
  virtual_network_type    = "Internal"
  redis_connection_string = module.redis.primary_connection_string
  redis_cache_id          = module.redis.id

  # This enables the Username and Password Identity Provider
  sign_up_enabled = true

  lock_enable = var.lock_enable

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

  # service_url = format("http://%s/pagopastorage", var.reverse_proxy_ip)
  service_url = format("https://%s", module.cstarblobstorage.primary_blob_host)

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

  service_url = format("https://%s/%s", module.cstarblobstorage.primary_blob_host, azurerm_storage_container.info_privacy.name)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_info_privacy/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

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

  service_url = format("https://%s/%s", module.cstarblobstorage.primary_blob_host,
  azurerm_storage_container.bpd_terms_and_conditions.name)

  content_value = templatefile("./api/bpd_tc/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

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
resource "azurerm_api_management_api_version_set" "bpd_hb_citizen" {
  name                = format("%s-bpd-hb-citizen", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Citizen API"
  versioning_scheme   = "Segment"
}

### Original (swagger 2.0.x)
module "bpd_hb_citizen_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_citizen.id

  description  = "Api and Models"
  display_name = "BPD HB Citizen API"
  path         = "bpd/hb/citizens"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_hb_citizen/original/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "delete",
      xml_content = templatefile("./api/bpd_hb_citizen/original/del_delete_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentCitizenHB",
      xml_content = templatefile("./api/bpd_hb_citizen/original/put_enrollment_citizen_hb.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "find",
      xml_content  = file("./api/bpd_hb_citizen/original/get_find_policy.xml")
    },
    {
      operation_id = "findranking",
      xml_content  = file("./api/bpd_hb_citizen/original/get_find_ranking.xml")
    },
    {
      operation_id = "updatePaymentMethod",
      xml_content  = file("./api/bpd_hb_citizen/original/patch_update_payment_method.xml")
    },
  ]
}

# V2 (openapi 3.0.x)
module "bpd_hb_citizen_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_citizen.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD HB Citizen API"
  path         = "bpd/hb/citizens"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile(format("./api/bpd_hb_citizen/v2/openapi.json.tpl"), {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "delete",
      xml_content = templatefile("./api/bpd_hb_citizen/v2/del_delete_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentCitizenHB",
      xml_content = templatefile("./api/bpd_hb_citizen/v2/put_enrollment_citizen_hb.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "find",
      xml_content  = file("./api/bpd_hb_citizen/v2/get_find_policy.xml")
    },
    {
      operation_id = "findranking",
      xml_content  = file("./api/bpd_hb_citizen/v2/get_find_ranking.xml")
    },
    {
      operation_id = "updatePaymentMethod",
      xml_content  = file("./api/bpd_hb_citizen/v2/patch_update_payment_method.xml")
    },
  ]
}

## 02 BPD HB Payment Instruments API ##
resource "azurerm_api_management_api_version_set" "bpd_hb_payment_instruments" {
  name                = format("%s-bpd-hb-payment-instruments", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Payment Instruments API"
  versioning_scheme   = "Segment"
}

### Original ###
module "bpd_hb_payment_instruments_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-payment-instruments-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_payment_instruments.id

  description  = ""
  display_name = "BPD HB Payment Instruments API"
  path         = "bpd/hb/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_payment_instruments/original/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # DEL BPay deletePaymentInstrumentHB
      operation_id = "delbpaydeletepaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/delbpaydeletepaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET BPay statusPaymentInstrumentHB
      operation_id = "getbpaystatuspaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/getbpaystatuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # DEL deletePaymentInstrumentHB
      operation_id = "deldeletepaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/deldeletepaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # PUT enrollPaymentInstrumentHB
      operation_id = "putenrollpaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB BPay
      operation_id = "putenrollpaymentinstrumenthbbpay",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbbpay_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB BPay ID
      operation_id = "putenrollpaymentinstrumenthbbpayid",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbbpayid_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB Other
      operation_id = "putenrollpaymentinstrumenthbother",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbother_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB Satispay
      operation_id = "putenrollpaymentinstrumenthbsatispay",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/putenrollpaymentinstrumenthbsatispay_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # GET statusPaymentInstrumentHB
      operation_id = "getstatuspaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/getstatuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
  ]
}

### V2 ###
module "bpd_hb_payment_instruments_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-payment-instruments-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_payment_instruments.id
  api_version         = "v2"

  description  = ""
  display_name = "BPD HB Payment Instruments API"
  path         = "bpd/hb/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_payment_instruments/v2/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # DEL BPay deletePaymentInstrumentHB
      operation_id = "delbpaydeletepaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/delbpaydeletepaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET BPay statusPaymentInstrumentHB
      operation_id = "getbpaystatuspaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/getbpaystatuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # DEL deletePaymentInstrumentHB
      operation_id = "deldeletepaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/deldeletepaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # PATCH patchPaymentInstrument
      operation_id = "patchpatchpaymentinstrument",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/patchpatchpaymentinstrument_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET statusPaymentInstrumentHB
      operation_id = "getstatuspaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/v2/getstatuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
  ]
}

## 03 BPD HB Winning Transactions API ##
resource "azurerm_api_management_api_version_set" "bpd_hb_winning_transactions" {
  name                = "bpd-hb-winning-transactions"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Winning Transactions API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_hb_winning_transactions_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_winning_transactions.id

  description  = "Api and Models"
  display_name = "BPD HB Winning Transactions API"
  path         = "bpd/hb/winning-transactions"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_hb_winning_transactions/original/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # GET getTotalCashback
      operation_id = "getgettotalcashback",
      xml_content = templatefile("./api/bpd_hb_winning_transactions/original/getgettotalcashback_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

### v2 ###
module "bpd_hb_winning_transactions_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_winning_transactions.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD HB Winning Transactions API"
  path         = "bpd/hb/winning-transactions"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpd/hb/winning-transactions/v2", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_winning_transactions/v2/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # GET getTotalCashback
      operation_id = "getgettotalcashback",
      xml_content = templatefile("./api/bpd_hb_winning_transactions/v2/getgettotalcashback_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

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
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_award_period.id

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
      xml_content = templatefile("./api/bpd_io_award_period/original/findAllUsingGET_policy.xml.tmpl", {
        env_short = var.env_short
      })
    }
  ]
}

### v2 ###
module "bpd_io_award_period_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_award_period.id
  api_version         = "v2"

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
      xml_content = templatefile("./api/bpd_io_award_period/v2/findAllUsingGET_policy.xml.tmpl", {
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
resource "azurerm_api_management_api_version_set" "bpd_hb_award_period" {
  name                = format("%s-bpd-hb-award-period", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Award Period API"
  versioning_scheme   = "Segment"
}

### Original ###
module "bdp_hb_award_period_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-award-period-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_award_period.id

  description  = "Api and Models"
  display_name = "BPD HB Award Period API"
  path         = "bpd/hb/award-periods"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_award_period/original/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # findall
      operation_id = "getfindall",
      xml_content  = file("./api/bpd_hb_award_period/original/getfindall_policy.xml")
    }
  ]
}

### v2 ###
module "bdp_hb_award_period_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-bpd-hb-award-period-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_award_period.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD HB Award Period API"
  path         = "bpd/hb/award-periods"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_award_period/v2/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # findall
      operation_id = "getfindall",
      xml_content  = file("./api/bpd_hb_award_period/v2/getfindall_policy.xml")
    }
  ]
}

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
