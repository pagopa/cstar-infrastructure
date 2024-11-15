module "rtp_cdn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn?ref=v8.44.3"

  name                  = "fe"
  prefix                = local.project
  resource_group_name   = azurerm_resource_group.rtp_frontend_rg.name
  location              = var.location
  https_rewrite_enabled = true

  hostname                         = local.rtp_cdn_domain
  index_document                   = "index.html"
  error_404_document               = "not_found.html"
  storage_account_replication_type = var.cdn_rtp.storage_account_replication_type

  querystring_caching_behaviour      = "BypassCaching"
  advanced_threat_protection_enabled = var.cdn_rtp.advanced_threat_protection_enabled

  log_analytics_workspace_id          = data.azurerm_log_analytics_workspace.log_analytics.id
  storage_account_nested_items_public = false

  # add public dns zone name
  dns_zone_name                = data.azurerm_dns_zone.cstar_public_dns_zone.name
  dns_zone_resource_group_name = data.azurerm_dns_zone.cstar_public_dns_zone.resource_group_name

  keyvault_vault_name          = data.azurerm_key_vault.kv_domain.name
  keyvault_resource_group_name = data.azurerm_key_vault.kv_domain.resource_group_name
  keyvault_subscription_id     = data.azurerm_subscription.current.subscription_id

  delivery_rule_rewrite = [{
    name  = "RewriteRulesForReactRouting"
    order = 2

    conditions = [{
      condition_type   = "url_file_extension_condition"
      operator         = "LessThan"
      match_values     = ["1"]
      transforms       = []
      negate_condition = false
    }]

    url_rewrite_action = {
      source_pattern          = "/"
      destination             = "/index.html"
      preserve_unmatched_path = false
    }
  }]

  global_delivery_rule = {
    cache_expiration_action       = []
    cache_key_query_string_action = []
    modify_request_header_action  = []

    # HSTS
    modify_response_header_action = [
      {
        action = "Overwrite"
        name   = "Strict-Transport-Security"
        value  = "max-age=31536000"
      },
      # Add Content Security Policy protection
    ]
  }


  tags = var.tags
}