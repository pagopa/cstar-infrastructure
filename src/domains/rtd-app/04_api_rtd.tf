## RTD Payment Manager API ##
# v1 #

module "rtd_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "rtd-api-product"
  display_name = "RTD_API_Product"
  description  = "RTD_API_Product"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/rtd_api/policy.xml")
}

module "rtd_api_product_internal" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "rtd-api-product-internal"
  display_name = "RTD_API_Product Internal"
  description  = "RTD_API_Product Internal"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 5

  policy_xml = templatefile("./api_product/rtd_api_internal/policy.xml.tpl", {
    k8s-cluster-ip-range-from     = var.k8s_ip_filter_range.from
    k8s-cluster-ip-range-to       = var.k8s_ip_filter_range.to
    k8s-cluster-aks-ip-range-from = var.k8s_ip_filter_range_aks.from
    k8s-cluster-aks-ip-range-to   = var.k8s_ip_filter_range_aks.to
  })
}
