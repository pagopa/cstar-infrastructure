resource "azurerm_subnet" "aca" {
  name                              = "${local.project}-aca-snet"
  resource_group_name               = data.azurerm_virtual_network.intern.resource_group_name
  virtual_network_name              = data.azurerm_virtual_network.intern.name
  address_prefixes                  = [var.aca_snet_cidr]
  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "Microsoft.App/environments"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "subnet_mcshared_cae" {
  name                              = "${local.project}-cae-snet"
  resource_group_name               = data.azurerm_virtual_network.intern.resource_group_name

  virtual_network_name              = data.azurerm_virtual_network.intern.name
  address_prefixes                  = [var.cidr_mcshared_cae_subnet]
  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "Microsoft.App/environments"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# Private endpoints subnet.
# ------------------------------------------------------------------------------
variable "core_private_endpoints_subnet_name" {
  type    = string
  default = "private-endpoint-snet"
}

data "azurerm_subnet" "private_endpoints" {
  name                 = var.core_private_endpoints_subnet_name
  virtual_network_name = var.core_virtual_network_name
  resource_group_name  = var.core_virtual_network_resource_group_name
}
