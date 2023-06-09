
module "rtd_senderack_download_file" {
  count  = var.enable.tae_api ? 1 : 0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-senderack-download", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

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
    rtd-ingress = local.ingress_load_balancer_hostname_https
  })

  product_ids = [azurerm_api_management_product.rtd_api_product.product_id]

  api_operation_policies = []
}
