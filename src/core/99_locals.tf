locals {
  project = "${var.prefix}-${var.env_short}"

  developer_domain  = "${local.apim_name}.developer.azure-api.net"
  portal_domain     = "portal.${var.dns_zone_prefix}.${var.external_domain}"
  management_domain = "management.${var.dns_zone_prefix}.${var.external_domain}"

  # Dns Forwarder
  dns_forwarder_vm_image_name = "${local.project}-dns-forwarder-ubuntu2204-image-v1"

  hostname_suffix = "%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"

  apim_name        = "${local.project}-apim"
  apim_hostname    = "api${local.hostname_suffix}"
  rtp_endpoint     = "https://rtp${local.hostname_suffix}"
  welfare_endpoint = "https://welfare${local.hostname_suffix}"

  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

  vnet_securehub_rg_name       = "${var.prefix}-${var.env_short}-itn-core-network-rg"
  vnet_securehub_core_hub_name = "${var.prefix}-${var.env_short}-itn-core-hub-vnet"

  secure_hub_vnets = { for r in data.azurerm_resources.vnets_secure_hub.resources : r.id => r }
  all_vnets        = { for vnet in data.azurerm_resources.vnets.resources : vnet.id => vnet }

  # DNS
  prefix_dns_zone_name = "${var.env == "prod" ? "" : "${var.env}."}${var.prefix}.pagopa.it"

  # Certificates
  app_gateway_api_certificate_name        = replace("${local.app_gateway_api_hostname}-stable", ".", "-")
  app_gateway_portal_certificate_name     = replace(local.app_gateway_portal_hostname, ".", "-")
  app_gateway_management_certificate_name = replace(local.app_gateway_management_hostname, ".", "-")
  app_gateway_api_io_certificate_name     = replace(local.app_gateway_api_io_hostname, ".", "-")
  app_gateway_api_emd_certificate_name    = replace(local.app_gateway_api_emd_hostname, ".", "-")
  app_gateway_api_rtp_certificate_name    = replace(local.app_gateway_api_rtp_hostname, ".", "-")
  app_gateway_api_rtp_cb_certificate_name = replace(local.app_gateway_api_rtp_cb_hostname, ".", "-")
  app_gateway_mcshared_certificate_name   = replace(local.app_gateway_mcshared_hostname, ".", "-")
  app_gateway_itw_certificate_name        = replace(local.app_gateway_itw_hostname, ".", "-")
  app_gateway_platform_certificate_name   = replace(local.app_gateway_platform_hostname, ".", "-")

  # Hostname:
  app_gateway_api_hostname        = "api${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_portal_hostname     = "portal${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_management_hostname = "management${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_api_io_hostname     = "api-io${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_api_emd_hostname    = "api-emd${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_api_rtp_hostname    = "api-rtp${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_api_rtp_cb_hostname = "api-rtp-cb${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_mcshared_hostname   = "api-mcshared${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_itw_hostname        = "api-itw${replace(".${local.prefix_dns_zone_name}", "-", ".")}"
  app_gateway_platform_hostname   = "platform${replace(".${local.prefix_dns_zone_name}", "-", ".")}"

}
