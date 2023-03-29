#
# VPN
#
module "vpn_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v3.15.0"
  name                 = "GatewaySubnet"
  address_prefixes     = var.cidr_subnet_vpn
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  service_endpoints    = []
  //enforce_private_link_endpoint_network_policies = true
}

data "azuread_application" "vpn_app" {
  display_name = "${local.project}-app-vpn"
}

module "vpn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//vpn_gateway?ref=v3.15.0"

  depends_on = [
    azurerm_log_analytics_workspace.log_analytics_workspace,
    module.operations_logs,
  ]

  name                = "${local.project}-vpn"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  sku                 = var.vpn_sku
  pip_sku             = var.vpn_pip_sku
  subnet_id           = module.vpn_snet.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  log_storage_account_id     = module.operations_logs.id

  vpn_client_configuration = [
    {
      address_space         = ["172.16.1.0/24"],
      vpn_client_protocols  = ["OpenVPN"],
      aad_audience          = data.azuread_application.vpn_app.application_id
      aad_issuer            = "https://sts.windows.net/${data.azurerm_subscription.current.tenant_id}/"
      aad_tenant            = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = var.tags
}

#
# DNS Forwarder
#
module "dns_forwarder_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v3.15.0"
  name                                      = "${local.project}-dnsforwarder-snet"
  address_prefixes                          = var.cidr_subnet_dnsforwarder
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "vpn_dns_forwarder" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//dns_forwarder?ref=v3.15.0"

  name                = "${local.project}-vpn-dnsfrw"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  subnet_id           = module.dns_forwarder_snet.id
  tags                = var.tags
}