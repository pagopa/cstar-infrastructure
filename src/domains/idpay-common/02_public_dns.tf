resource "azurerm_dns_ns_record" "main" {
  for_each            = { for r in var.ns_dns_records_welfare : r.name => r }
  name                = each.key
  zone_name           = data.terraform_remote_state.core.outputs.dns_zone_welfare_name
  resource_group_name = data.terraform_remote_state.core.outputs.vnet_name_rg
  records             = each.value.records

  ttl  = var.dns_default_ttl_sec
  tags = var.tags

}