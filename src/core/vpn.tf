#
# VPN
#
module "vpn_snet" {
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.18.10"
  name                                           = "GatewaySubnet"
  address_prefixes                               = var.cidr_subnet_vpn
  resource_group_name                            = azurerm_resource_group.rg_vnet.name
  virtual_network_name                           = module.vnet.name
  service_endpoints                              = []
  enforce_private_link_endpoint_network_policies = true
}

data "azuread_application" "vpn_app" {
  display_name = "${local.project}-app-vpn"
}

module "vpn" {
  source = "git::https://github.com/pagopa/azurerm.git//vpn_gateway?ref=v2.18.10"

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
  source                                         = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.18.10"
  name                                           = "${local.project}-dnsforwarder-snet"
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
  name                = "${local.project}-dnsforwarder-netprofile"
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

resource "azurerm_resource_group" "dns_forwarder" {

  name     = "${local.project}-dns-forwarder-rg"
  location = var.location

  tags = var.tags
}


resource "azurerm_storage_account" "dns_forwarder" {

  name                      = replace("${local.project}-dnsfwd-st", "-", "")
  resource_group_name       = azurerm_resource_group.dns_forwarder.name
  location                  = var.location
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  account_tier              = "Standard"

  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_share" "dns_forwarder" {

  name = "${local.project}-dns-forwarder-share"

  storage_account_name = azurerm_storage_account.dns_forwarder.name

  quota = 1
}

resource "azurerm_container_group" "coredns_forwarder" {

  name                = "${local.project}-dns-forwarder"
  location            = azurerm_resource_group.dns_forwarder.location
  resource_group_name = azurerm_resource_group.dns_forwarder.name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.dns_forwarder.id
  os_type             = "Linux"

  container {
    name   = "dns-forwarder"
    image  = "coredns/coredns:1.8.4"
    cpu    = "0.5"
    memory = "0.5"

    commands = ["/coredns", "-conf", "/app/conf/Corefile"]

    ports {
      port     = 53
      protocol = "UDP"
    }

    ports {
      port     = 8080
      protocol = "TCP"
    }

    ports {
      port     = 8181
      protocol = "TCP"
    }

    environment_variables = {

    }

    /*
    readiness_probe {
      http_get {
        path   = "/ready"
        port   = 8181
        scheme = "Http"
      }
      failure_threshold     = 3
      initial_delay_seconds = 0
      period_seconds        = 10
      success_threshold     = 1
      timeout_seconds       = 1
    }

    liveness_probe {
      http_get {
        path   = "/health"
        port   = 8080
        scheme = "Http"
      }
      failure_threshold     = 5
      initial_delay_seconds = 60
      period_seconds        = 10
      success_threshold     = 1
      timeout_seconds       = 5
    }
*/

    volume {
      mount_path = "/app/conf"
      name       = "dns-forwarder-conf"
      read_only  = false
      share_name = azurerm_storage_share.dns_forwarder.name

      storage_account_key  = azurerm_storage_account.dns_forwarder.primary_access_key
      storage_account_name = azurerm_storage_account.dns_forwarder.name
    }

  }


  depends_on = [
    null_resource.upload_corefile
  ]

  tags = var.tags
}

data "local_file" "corefile" {
  filename = "${path.module}/dns/Corefile"
}

resource "null_resource" "upload_corefile" {

  triggers = {
    "changes-in-config" : md5(data.local_file.corefile.content)
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage file upload \
                --account-name ${azurerm_storage_account.dns_forwarder.name} \
                --account-key ${azurerm_storage_account.dns_forwarder.primary_access_key} \
                --share-name ${azurerm_storage_share.dns_forwarder.name} \
                --source "${path.module}/dns/Corefile"
          EOT
  }
}
