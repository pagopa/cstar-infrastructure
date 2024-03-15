resource "azurerm_resource_group" "rg_api" {
  name     = "${local.project}-api-rg"
  location = var.location

  tags = var.tags
}

locals {
  apim_cert_name_proxy_endpoint   = "${local.project}-proxy-endpoint-cert"
  portal_cert_name_proxy_endpoint = "portal-proxy-endpoint-cert"

  api_domain        = "api.${var.dns_zone_prefix}.${var.external_domain}"
  portal_domain     = "portal.${var.dns_zone_prefix}.${var.external_domain}"
  management_domain = "management.${var.dns_zone_prefix}.${var.external_domain}"
}


###########################
## Api Management (apim) ##
###########################

module "apim" {

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v7.69.1"
  subnet_id            = module.apim_snet.id
  location             = azurerm_resource_group.rg_api.location
  name                 = "${local.project}-apim"
  resource_group_name  = azurerm_resource_group.rg_api.name
  publisher_name       = var.apim_publisher_name
  publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name             = var.apim_sku
  virtual_network_type = "Internal"
  public_ip_address_id = azurerm_public_ip.apim_v2_management_public_ip.id

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

  application_insights = {
    enabled             = true
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }

  xml_content = templatefile("./api/base_policy.tpl", {
    portal-domain         = local.portal_domain
    management-api-domain = local.management_domain
    cors-global-only      = false # if true only global policy will check cors, otherwise other cors policy can be defined. (UAT for FA POC)
    apim-name             = "${local.project}-apim"
  })

  tags = var.tags

  depends_on = [
    azurerm_application_insights.application_insights
  ]
}

resource "azurerm_api_management_custom_domain" "api_custom_domain" {
  api_management_id = module.apim.id

  gateway {
    host_name = local.api_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.app_gw_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.app_gw_cstar.version}",
      ""
    )
  }

  gateway {
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

resource "azurerm_api_management_notification_recipient_email" "email_assistenza_on_new_subscription" {
  api_management_id = module.apim.id
  notification_type = "RequestPublisherNotificationMessage"
  email             = var.cstar_support_email
}

#########
## API ##
#########

## monitor ##
module "monitor" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = "${var.env_short}-monitor"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Monitor"
  display_name = "Monitor"
  path         = ""
  protocols    = ["https"]

  service_url = null

  content_format = "openapi"
  content_value = templatefile("./api/monitor/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
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


module "app_io_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "app-io-product"
  display_name = "APP_IO_PRODUCT"
  description  = "APP_IO_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = templatefile("./api_product/app_io/policy.xml", {
    env_short             = var.env_short
    ingress_load_balancer = local.ingress_load_balancer_hostname_https
    appio_timeout_sec     = var.appio_timeout_sec
  })
}
