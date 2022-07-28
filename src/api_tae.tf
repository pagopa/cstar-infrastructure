## RTD CSV Transaction Decrypted API ##

locals {
  rtd_senderack_download_file_uri = format("https://%s/%s", azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn, azurerm_storage_container.sender_ade_ack[0].name)
}

module "rtd_senderack_download_file" {
  count  = var.enable.tae.api ? 1 : 0
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.3"

  name                = format("%s-senderack-download", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "API to download Sender ADE Ack Files"
  display_name = "RTD Sender ADE ACK Files Download"
  path         = "ade"
  protocols    = ["https"]

  service_url = local.rtd_senderack_download_file_uri

  content_format = "openapi"
  content_value = templatefile("./api/rtd_senderack_download_file/openapi.json.tpl", {
    host = local.rtd_senderack_download_file_uri
  })

  subscription_required = true

  xml_content = templatefile("./api/rtd_senderack_download_file/azureblob_policy.xml", {
    rtd-ingress-ip = var.reverse_proxy_ip
  })

  product_ids = [module.rtd_api_product.product_id]

  api_operation_policies = []
}