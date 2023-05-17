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

  xml_content = templatefile("./api_product/rtd_api_internal/policy.xml.tpl", {
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
module "rtd_payment_instrument_manager" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-rtd-payment-instrument-manager-api", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  description         = ""
  display_name        = "RTD Payment Instrument Manager API"
  path                = "rtd/payment-instrument-manager"
  protocols           = ["https", "http"]
  service_url         = format("http://%s/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager", var.reverse_proxy_ip_old_k8s)

  version_set_id = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id

  content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml.tpl", {
    host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "get-hash-salt",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
        mock_response                        = var.env_short == "d" || var.env_short == "u" || var.env_short == "p"
        pagopa-platform-api-key-name         = "pagopa-platform-apim-api-key-primary"
      })
    },
    {
      operation_id = "get-hashed-pans",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy.xml.tpl", {
        # as-is due an application error in prod -->  to-be
        # host = var.env_short == "p" ? "prod.cstar.pagopa.it" : trim(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
        host = trim(data.azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
      })
    },
  ]
}

# v2
module "rtd_payment_instrument_manager_v2" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  # cause this api relies on new container, enable it when container is enabled
  count = var.enable.hashed_pans_container ? 1 : 0

  name                = "${var.env_short}-rtd-payment-instrument-manager-api"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  description         = ""
  display_name        = "RTD Payment Instrument Manager API"
  path                = "rtd/payment-instrument-manager"
  protocols           = ["https", "http"]
  service_url         = "http://${var.reverse_proxy_ip_old_k8s}/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager"
  version_set_id      = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id
  api_version         = "v2"

  # depends on module v1
  #depends_on = [module.rtd_payment_instrument_manager]

  content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml.tpl", {
    host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "get-hash-salt",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml.tpl", {
        pm-backend-url                       = var.pagopa_platform_url,
        rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
        mock_response                        = var.env_short == "d" || var.env_short == "u" || var.env_short == "p"
        pagopa-platform-api-key-name         = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
      })
    },
    {
      operation_id = "get-hashed-pans",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy-rev2.xml.tpl", {
        blob-storage-access-key       = data.azurerm_storage_account.cstarblobstorage.primary_access_key,
        blob-storage-account-name     = data.azurerm_storage_account.cstarblobstorage.name,
        blob-storage-private-fqdn     = local.cstarblobstorage_private_fqdn,
        blob-storage-container-prefix = azurerm_storage_container.cstar_hashed_pans[0].name
      })
    },
  ]
}

## v3 ##
module "rtd_payment_instrument_manager_v3" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  # cause this api relies on new container, enable it when container is enabled
  count = 1

  name                = "${var.env_short}-rtd-payment-instrument-manager-api"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  description         = ""
  display_name        = "RTD Payment Instrument Manager API"
  path                = "rtd/payment-instrument-manager"
  protocols           = ["https", "http"]
  service_url         = "http://${var.reverse_proxy_ip_old_k8s}/rtdmspaymentinstrumentmanager/rtd/payment-instrument-manager"
  version_set_id      = azurerm_api_management_api_version_set.rtd_payment_instrument_manager.id
  api_version         = "v3"

  #depends_on = [module.rtd_payment_instrument_manager]

  content_value = templatefile("./api/rtd_payment_instrument_manager/swagger.xml.tpl", {
    host = local.appgw_api_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [azurerm_api_management_product.rtd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "get-hash-salt",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hash-salt_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        rtd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint.value
        mock_response                        = false
        pagopa-platform-api-key-name         = "pagopa-platform-apim-api-key-primary"
      })
    },
    {
      operation_id = "get-hashed-pans",
      xml_content = templatefile("./api/rtd_payment_instrument_manager/get-hashed-pans-policy-rev3.xml.tpl", {
        blob-storage-private-fqdn     = local.cstarblobstorage_private_fqdn,
        blob-storage-container-prefix = azurerm_storage_container.cstar_hashed_pans_par[0].name
      })
    },
  ]
}
