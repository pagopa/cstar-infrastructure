resource "azurerm_resource_group" "rg_welfare" {
  name     = "${local.product}-welfare-rg"
  location = var.location
  tags     = var.tags
}

module "selfcare_welfare_cdn" {
  source = "git::https://github.com/pagopa/azurerm.git//cdn?ref=v4.0.0"

  name                = format("welfare-selfcare-%s", var.env_short)
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg_welfare.name
  location            = var.location

  hostname              = "selfcare"
  https_rewrite_enabled = true
  lock_enabled          = false

  index_document     = "index.html"
  error_404_document = "not_found.html"

  dns_zone_name                = data.terraform_remote_state.core.outputs.dns_zone_welfare_name
  dns_zone_resource_group_name = data.terraform_remote_state.core.outputs.vnet_name_rg

  querystring_caching_behaviour = "BypassCaching"

  // https://antbutcher.medium.com/hosting-a-react-js-app-on-azure-blob-storage-azure-cdn-for-ssl-and-routing-8fdf4a48feeb
  // it is important to add base tag in index.html too (i.e. <base href="/">)
  delivery_rule_rewrite = [{
    name  = "RewriteRules"
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
    modify_response_header_action = [{
      action = "Overwrite"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000"
      },
    ]
  }

  tags = var.tags
}