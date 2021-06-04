resource "azurerm_resource_group" "rg_api" {
  name     = format("%s-api-rg", local.project)
  location = var.location

  tags = var.tags
}

locals {
  apim_cert_name_proxy_endpoint = format("%s-proxy-endpoint-cert", local.project)
}

###########################
## Api Management (apim) ## 
###########################

module "apim" {
  source               = "git::https://github.com/pagopa/azurerm.git//api_management?ref=main"
  subnet_id            = module.apim_snet.id
  location             = azurerm_resource_group.rg_api.location
  name                 = format("%s-apim", local.project)
  resource_group_name  = azurerm_resource_group.rg_api.name
  publisher_name       = var.apim_publisher_name
  publisher_email      = var.apim_publisher_email
  sku_name             = var.apim_sku
  virtual_network_type = "Internal"

  # policy_path = "./api/base_policy.xml"

  tags = var.tags
}

resource "azurerm_api_management_custom_domain" "api_custom_domain" {
  api_management_id = module.apim.id

  proxy {
    host_name    = trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
    key_vault_id = azurerm_key_vault_certificate.apim_proxy_endpoint_cert.secret_id
  }

  # developer_portal {
  #   host_name    = "portal.example.com"
  #   key_vault_id = azurerm_key_vault_certificate.test.secret_id
  # }
}

module "api_bdp_hb_award_period" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.2"

  name                = "bpd-hb-award-period-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD HB Award Period API"
  path         = "bpd/hb/award-periods"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.aks_external_ip)

  content_value = templatefile("./api/bpd_hb_award_period/swagger.json.tpl", {
  })

  xml_content = file("./api/base_policy.xml")

}

resource "azurerm_api_management_api_operation_policy" "bdp_hb_award_period_findall" {
  depends_on          = [module.api_bdp_hb_award_period]
  api_name            = "bpd-hb-award-period-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  operation_id        = "findAll"

  xml_content = file("./api/bpd_hb_award_period/findall_policy.xml")
}

resource "azurerm_api_management_api_operation_policy" "bdp_hb_award_period_test_cache" {
  depends_on          = [module.api_bdp_hb_award_period]
  api_name            = "bpd-hb-award-period-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  operation_id        = "testcache"

  xml_content = file("./api/bpd_hb_award_period/test_cache_policy.xml")
}

module "api_bdp_info_privacy" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.2"
  name                = "bpd-info-privacy"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD Info Privacy"
  path         = "cstar-bpd"
  protocols    = ["https"]

  service_url = format("https://%s/%s", module.cstarblobstorage.primary_blob_host, azurerm_storage_container.info_privacy.name)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_info_privacy/openapi.json.tpl", {
  })

  xml_content = file("./api/bpd_info_privacy/policy.xml")

}

module "bpd_io_award_period" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.2"

  name                = "bpd-io-award-period-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.aks_external_ip)

  content_value = templatefile("./api/bpd_io_award_period/swagger.json.tpl", {
  })

  xml_content = file("./api/bpd_io_award_period/policy.xml")

}