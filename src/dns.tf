resource "azurerm_dns_zone" "public" {
  count               = (var.dns_zone_prefix == null || var.external_domain == null) ? 0 : 1
  name                = join(".", [var.dns_zone_prefix, var.external_domain])
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

# Dev public DNS delegation
resource "azurerm_dns_ns_record" "cstar_dev_pagopa_it_ns" {
  count               = var.env_short == "p" ? 1 : 0
  name                = format("%s-dev-ns-record", local.project)
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.rg_vnet.name
  records = [
    "ns1-09.azure-dns.com.",
    "ns2-09.azure-dns.net.",
    "ns3-09.azure-dns.org.",
    "ns4-09.azure-dns.info.",
  ]
  ttl  = var.dns_default_ttl_sec
  tags = var.tags
}