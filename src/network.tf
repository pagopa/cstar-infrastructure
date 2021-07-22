resource "azurerm_resource_group" "rg_vnet" {
  name     = format("%s-vnet-rg", local.project)
  location = var.location

  tags = var.tags
}

module "vnet" {
  source              = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v1.0.7"
  name                = format("%s-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_vnet

  tags = var.tags

}

## Database subnet
module "db_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = format("%s-db-snet", local.project)
  address_prefixes                               = var.cidr_subnet_db
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  service_endpoints                              = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}

module "redis_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  count                = var.redis_sku_name == "Premium" && length(var.cidr_subnet_redis) > 0 ? 1 : 0
  name                 = format("%s-redis-snet", local.project)
  address_prefixes     = var.cidr_subnet_redis
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
}

# k8s cluster subnet 
module "k8s_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = format("%s-k8s-snet", local.project)
  address_prefixes                               = var.cidr_subnet_k8s
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}

## Subnet jumpbox
module "jumpbox_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                 = format("%s-jumpbox-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_jumpbox

}

module "azdoa_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.3"
  count                                          = var.enable_azdoa ? 1 : 0
  name                                           = format("%s-azdoa-snet", local.project)
  address_prefixes                               = var.cidr_subnet_azdoa
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  enforce_private_link_endpoint_network_policies = true
}

# Subnet to host the application gateway
module "appgateway-snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                 = format("%s-appgateway-snet", local.project)
  address_prefixes     = var.cidr_subnet_appgateway
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
}

# vnet integration
module "vnet_integration" {
  source              = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v1.0.26"
  name                = format("%s-integration-vnet", local.project)
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  address_space       = var.cidr_integration_vnet

  tags = var.tags
}

# APIM subnet
module "apim_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                 = format("%s-apim-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet_integration.name
  address_prefixes     = var.cidr_subnet_apim

  service_endpoints = ["Microsoft.Web"]

  enforce_private_link_endpoint_network_policies = true
}

## Eventhub subnet
module "eventhub_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = format("%s-eventhub-snet", local.project)
  address_prefixes                               = var.cidr_subnet_eventhub
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet_integration.name
  service_endpoints                              = ["Microsoft.EventHub"]
  enforce_private_link_endpoint_network_policies = true
}

module "lb_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = format("%s-lb-snet", local.project)
  address_prefixes                               = ["10.230.7.128/28"]
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet_integration.name
  service_endpoints                              = []
  enforce_private_link_endpoint_network_policies = true
}

## Peering between the vnet(main) and integration vnet 
module "vnet_peering" {
  source = "git::https://github.com/pagopa/azurerm.git//virtual_network_peering?ref=v1.0.30"

  location = azurerm_resource_group.rg_vnet.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet.name
  source_remote_virtual_network_id = module.vnet.id
  source_allow_gateway_transit     = true # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet_integration.name
  target_remote_virtual_network_id = module.vnet_integration.id
  target_use_remote_gateways       = true # needed by vpn gateway for enabling routing from vnet to vnet_integration
}

## Application gateway public ip ##
resource "azurerm_public_ip" "apigateway_public_ip" {
  name                = format("%s-appgateway-pip", local.project)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}


resource "azurerm_private_dns_zone" "api_private_dns_zone" {
  name                = var.apim_private_domain
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "api_private_dns_zone_virtual_network_link" {
  name                  = format("%s-api-private-dns-zone-link", local.project)
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.api_private_dns_zone.name
  virtual_network_id    = module.vnet.id
}

resource "azurerm_private_dns_a_record" "private_dns_a_record_api" {
  name                = module.apim.name
  zone_name           = azurerm_private_dns_zone.api_private_dns_zone.name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  ttl                 = 300
  records             = module.apim.*.private_ip_addresses[0]
}


## Application gateway ## 
# Since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name       = format("%s-appgw-be-address-pool", local.project)
  frontend_http_port_name         = format("%s-appgw-fe-http-port", local.project)
  frontend_https_port_name        = format("%s-appgw-fe-https-port", local.project)
  frontend_ip_configuration_name  = format("%s-appgw-fe-ip-configuration", local.project)
  http_setting_name               = format("%s-appgw-be-http-settings", local.project)
  http_listener_name              = format("%s-appgw-fe-http-settings", local.project)
  https_listener_name             = format("%s-appgw-fe-https-settings", local.project)
  http_request_routing_rule_name  = format("%s-appgw-http-reqs-routing-rule", local.project)
  https_request_routing_rule_name = format("%s-appgw-https-reqs-routing-rule", local.project)
  acme_le_ssl_cert_name           = format("%s-appgw-acme-le-ssl-cert", local.project)
  http_to_https_redirect_rule     = format("%s-appgw-http-to-https-redirect-rule", local.project)
}

# Application gateway: Multilistener configuraiton
module "app_gw" {
  source = "./modules/app_gw"

  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  name                = format("%s-app-gw", local.project)

  # SKU
  sku_name = "WAF_v2"
  sku_tier = "WAF_v2"

  # Networking
  subnet_id    = module.appgateway-snet.id
  public_ip_id = azurerm_public_ip.apigateway_public_ip.id

  # Configure backends
  backends = {
    apim = {
      protocol = "Http"
      host     = trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
      port     = 80
      probe    = "/status-0123456789abcdef"
    }
  }

  # Configure listeners
  listeners = {
    app_io = {
      protocol = "Https"
      host     = var.env_short == "p" ? "api-io.cstar.pagopa.it" : format("api-io.%s.cstar.pagopa.it", lower(var.tags["Environment"]))
      port     = 443
      certificate = {
        name = var.app_gateway_api_io_certificate_name != null ? var.app_gateway_api_io_certificate_name : azurerm_key_vault_certificate.app_gw_io_cstar[0].name
        id   = var.app_gateway_api_io_certificate_name != null ? trimsuffix(data.azurerm_key_vault_certificate.app_gw_io_cstar[0].secret_id, data.azurerm_key_vault_certificate.app_gw_io_cstar[0].version) : trimsuffix(azurerm_key_vault_certificate.app_gw_io_cstar[0].secret_id, azurerm_key_vault_certificate.app_gw_io_cstar[0].version)
      }
    }

    issuer_acquirer = {
      protocol = "Https"
      host     = var.env_short == "p" ? "api.cstar.pagopa.it" : format("api.%s.cstar.pagopa.it", lower(var.tags["Environment"]))
      port     = 443
      certificate = {
        name = var.app_gateway_api_certificate_name != null ? var.app_gateway_api_certificate_name : azurerm_key_vault_certificate.app_gw_cstar[0].name
        id   = var.app_gateway_api_certificate_name != null ? trimsuffix(data.azurerm_key_vault_certificate.app_gw_cstar[0].secret_id, data.azurerm_key_vault_certificate.app_gw_cstar[0].version) : trimsuffix(azurerm_key_vault_certificate.app_gw_cstar[0].secret_id, azurerm_key_vault_certificate.app_gw_cstar[0].version)
      }
    }
  }

  # maps listener to backend
  routes = {

    api = {
      listener = "app_io"
      backend  = "apim"
    }

    broker = {
      listener = "issuer_acquirer"
      backend  = "apim"
    }
  }


  # TLS
  identity_ids = [azurerm_user_assigned_identity.appgateway.id]

  # Scaling
  app_gateway_min_capacity = "1"
  app_gateway_max_capacity = "2"


  tags = var.tags
}

resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = format("%s-aksoutbound-pip-%02d", local.project, count.index + 1)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}

module "route_table_peering_sia" {
  source = "git::https://github.com/pagopa/azurerm.git//route_table?ref=v1.0.25"

  name                          = format("%s-sia-rt", local.project)
  location                      = azurerm_resource_group.rg_vnet.location
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  disable_bgp_route_propagation = false

  subnet_ids = [module.apim_snet.id, module.eventhub_snet.id, module.lb_snet.id]

  routes = [{
    # production
    name                   = "to-sia-prod-subnet"
    address_prefix         = "10.70.132.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-sia-uat-subnet"
      address_prefix         = "10.70.67.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-apim-sia-uat-subnet"
      address_prefix         = "10.70.65.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # prod
      name                   = "to-apim-sia-prod-subnet"
      address_prefix         = "10.70.133.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
  }]

  tags = var.tags
}

## VPN subnet
module "vpn_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = "GatewaySubnet"
  address_prefixes                               = var.cidr_subnet_vpn
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  service_endpoints                              = []
  enforce_private_link_endpoint_network_policies = true
}

data "azuread_application" "vpn_app" {
  display_name = format("%s-app-vpn", local.project)
}

module "vpn" {
  source = "git::https://github.com/pagopa/azurerm.git//vpn_gateway?ref=v1.0.36"

  name                = format("%s-vpn", local.project)
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
      aad_issuer            = format("https://sts.windows.net/%s/", data.azurerm_subscription.current.tenant_id)
      aad_tenant            = format("https://login.microsoftonline.com/%s", data.azurerm_subscription.current.tenant_id)
      radius_server_address = null
      radius_server_secret  = null
      revoked_certificate   = []
      root_certificate      = []
    }
  ]

  tags = var.tags
}

## DNS Forwarder subnet
module "dns_forwarder_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = format("%s-dnsforwarder-snet", local.project)
  address_prefixes                               = var.cidr_subnet_dnsforwarder
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  enforce_private_link_endpoint_network_policies = true

  delegation = {
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_profile" "dns_forwarder" {
  name                = format("%s-dnsforwarder-netprofile", local.project)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name

  container_network_interface {
    name = "container-nic"

    ip_configuration {
      name      = "ip-config"
      subnet_id = module.dns_forwarder_snet.id
    }
  }
}

module "integration_lb" {
  count = var.env_short != "d" ? 1 : 0

  source                                 = "git::https://github.com/pagopa/azurerm.git//load_balancer?ref=fix-lb-module"
  name                                   = format("%s-integration", local.project)
  resource_group_name                    = azurerm_resource_group.rg_vnet.name
  location                               = var.location
  type                                   = "private"
  frontend_subnet_id                     = module.lb_snet.id
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = var.lb_integration_frontend_ip
  lb_sku                                 = "Standard"
  pip_sku                                = "Standard" #`pip_sku` must match `lb_sku`

  lb_backend_pools = [
    {
      name = "sftp-sia"
      ips = [
        {
          ip      = "10.92.8.180" # TODO
          vnet_id = module.vnet_integration.id
        }
      ]
    }
  ]

  lb_port = {
    sftp-sia = {
      frontend_port     = "8022"
      protocol          = "Tcp"
      backend_port      = "8022",
      backend_pool_name = "sftp-sia"
      probe_name        = "tcp-8022"
    }
  }

  lb_probe = {
    tcp-8022 = {
      protocol     = "Tcp"
      port         = "8022"
      request_path = ""
    }
  }

  tags = var.tags
}


resource "azurerm_network_interface" "hub-nva-nic" {
  name                          = format("%s-nva-nic", local.project)
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "ip-config-nva"
    subnet_id                     = module.lb_snet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.230.7.133" # TODO
  }

  tags = var.tags
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}


resource "azurerm_virtual_machine" "hub-nva-vm" {
  name                  = format("%s-nva-vm", local.project)
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  network_interface_ids = [azurerm_network_interface.hub-nva-nic.id]
  vm_size               = "Standard_D4s_v3"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = format("%s-nva-vm", local.project)
    admin_username = "azureuser"
    admin_password = random_password.password.result
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "enable-routes" {
  name                 = "enable-iptables-routes"
  virtual_machine_id   = azurerm_virtual_machine.hub-nva-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"


  # sudo iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 10.230.7.133
  settings = <<SETTINGS
    {
        "fileUris": [
        "https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/linux/enable-ip-forwarding.sh"
        ],
        "commandToExecute": "bash enable-ip-forwarding.sh"
    }
SETTINGS

  tags = var.tags
}

resource "azurerm_route_table" "hub-gateway-rt" {
  name                          = "hub-gateway-rt"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  disable_bgp_route_propagation = false

  route { # TODO
    name                   = "to-sia-uat-subnet"
    address_prefix         = "10.70.67.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.230.7.133"
  }

  route { # TODO
    name                   = "to-apim-sia-uat-subnet"
    address_prefix         = "10.70.65.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.230.7.133"
  }

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "hub-gateway-rt-hub-vnet-gateway-subnet" {
  subnet_id      = module.k8s_snet.id
  route_table_id = azurerm_route_table.hub-gateway-rt.id
  depends_on     = [module.lb_snet]
}
