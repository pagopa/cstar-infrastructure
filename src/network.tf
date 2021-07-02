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

## Eventhub subnet
module "eventhub_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                                           = format("%s-eventhub-snet", local.project)
  address_prefixes                               = var.cidr_subnet_eventhub
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  service_endpoints                              = ["Microsoft.EventHub"]
  enforce_private_link_endpoint_network_policies = true
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

# APIM subnet
module "apim_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  name                 = format("%s-apim-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_apim

  service_endpoints = ["Microsoft.Web"]

  enforce_private_link_endpoint_network_policies = true
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
      host     = format("%s-io.cstar.pagopa.it", lower(var.tags["Environment"]))
      port     = 443
      certificate = {
        name = azurerm_key_vault_certificate.app_gw_io_cstar.name
        id   = trimsuffix(azurerm_key_vault_certificate.app_gw_io_cstar.secret_id, azurerm_key_vault_certificate.app_gw_io_cstar.version)
      }
    }

    issuer_acquirer = {
      protocol = "Https"
      host     = format("%s.cstar.pagopa.it", lower(var.tags["Environment"]))
      port     = 443
      certificate = {
        name = azurerm_key_vault_certificate.app_gw_cstar.name
        id   = trimsuffix(azurerm_key_vault_certificate.app_gw_cstar.secret_id, azurerm_key_vault_certificate.app_gw_cstar.version)
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

}

/*
resource "azurerm_application_gateway" "app_gateway" {
  name                = format("%s-api-gateway", local.project)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  enable_http2 = true

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  gateway_ip_configuration {
    name      = format("%s-appgw-gw-ip-configuration", local.project)
    subnet_id = module.appgateway-snet.id
  }

  frontend_port {
    name = local.frontend_http_port_name
    port = 80
  }

  dynamic "frontend_port" {
    for_each = var.enable_custom_dns ? [true] : []
    content {
      name = local.frontend_https_port_name
      port = 443
    }
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.apigateway_public_ip.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    fqdns        = [trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")]
    ip_addresses = []
  }

  backend_http_settings {
    name                  = local.http_setting_name
    host_name             = trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "probe-apim"
  }

  probe {
    host                                      = trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
    minimum_servers                           = 0
    name                                      = "probe-apim"
    path                                      = "/status-0123456789abcdef"
    pick_host_name_from_backend_http_settings = false
    protocol                                  = "Http"
    timeout                                   = 30
    interval                                  = 30
    unhealthy_threshold                       = 3

    match {
      status_code = ["200-399"]
    }
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_http_port_name
    protocol                       = "Http"
  }

  dynamic "http_listener" {
    for_each = var.enable_custom_dns ? [true] : []
    content {
      name                           = local.https_listener_name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_https_port_name
      protocol                       = "Https"
      ssl_certificate_name           = var.app_gateway_certificate_name
      require_sni                    = true
      host_name                      = var.app_gateway_host_name
    }
  }

  request_routing_rule {
    name                       = local.http_request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  dynamic "request_routing_rule" {
    for_each = var.enable_custom_dns ? [true] : []
    content {
      name                       = local.https_request_routing_rule_name
      rule_type                  = "Basic"
      http_listener_name         = local.https_listener_name
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name
    }
  }


  dynamic "ssl_certificate" {
    for_each = var.enable_custom_dns ? [true] : []
    content {
      name                = data.azurerm_key_vault_secret.app_gw_cert[0].name
      key_vault_secret_id = trimsuffix(data.azurerm_key_vault_secret.app_gw_cert[0].id, data.azurerm_key_vault_secret.app_gw_cert[0].version)
    }

  }

  dynamic "redirect_configuration" {
    for_each = var.enable_custom_dns ? [true] : []
    content {
      name                 = local.http_to_https_redirect_rule
      redirect_type        = "Permanent"
      target_listener_name = local.https_listener_name
      include_path         = true
      include_query_string = true
    }

  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgateway.id]
  }


  waf_configuration {
    enabled                  = true
    firewall_mode            = "Detection"
    rule_set_type            = "OWASP"
    rule_set_version         = "3.1"
    request_body_check       = true
    file_upload_limit_mb     = 100
    max_request_body_size_kb = 128
  }

  autoscale_configuration {
    min_capacity = var.app_gateway_min_capacity
    max_capacity = var.app_gateway_max_capacity
  }

  tags = var.tags
}

*/

/*
module "nat_gateway" {
  source = "git::https://github.com/pagopa/azurerm.git//nat_gateway?ref=v1.0.7"

  resource_group_name = azurerm_resource_group.rg_vnet.name
  name                = format("%s-natgw", local.project)
  location            = var.location
  # TODO: associate the nat gateway to one or more subnet
  subnet_ids = []
  tags       = var.tags

}
*/

resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = format("%s-aksoutbound-pip-%02d", local.project, count.index + 1)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}

