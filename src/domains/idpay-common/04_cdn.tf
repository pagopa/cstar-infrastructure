/**
 * Checkout resource group
 **/
resource "azurerm_resource_group" "fe_rg_idpay" {
  name     = "${local.product}-${var.domain}-cdn-rg"
  location = var.location

  tags = var.tags
}

#data "azurerm_dns_zone" "public" {
#  name                = join(".", [var.dns_zone_prefix, var.external_domain])
#  resource_group_name = azurerm_resource_group.rg_vnet.name
#}

locals {
  spa = [
    for i, spa in var.spa :
    {
      name  = replace(replace("SPA-${spa}", "-", ""), "/", "0")
      order = i + 3 // +3 required because the order start from 1: 1 is reserved for default application redirect; 2 is reserved for the https rewrite;
      conditions = [
        {
          condition_type   = "url_path_condition"
          operator         = "BeginsWith"
          match_values     = [format("/%s/", spa)]
          negate_condition = false
          transforms       = null
        },
        {
          condition_type   = "url_file_extension_condition"
          operator         = "LessThanOrEqual"
          match_values     = ["0"]
          negate_condition = false
          transforms       = null
        },
      ]
      url_rewrite_action = {
        source_pattern          = format("/%s/", spa)
        destination             = format("/%s/index.html", spa)
        preserve_unmatched_path = false
      }
    }
  ]
}

/**
 * CDN
 */
// public storage used to serve FE
module "idpay_cdn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn?ref=v6.18.0"

  name                  = "idpaycdn"
  prefix                = local.project
  resource_group_name   = azurerm_resource_group.fe_rg_idpay.name
  location              = var.location
  hostname              = "welfare.${data.azurerm_dns_zone.public.name}"
  https_rewrite_enabled = true

  index_document     = "index.html"
  error_404_document = "error.html"

  dns_zone_name                = data.azurerm_dns_zone.public.name
  dns_zone_resource_group_name = data.azurerm_dns_zone.public.resource_group_name

  keyvault_resource_group_name = module.key_vault_idpay.resource_group_name
  keyvault_subscription_id     = data.azurerm_subscription.current.subscription_id
  keyvault_vault_name          = module.key_vault_idpay.name

  querystring_caching_behaviour = "BypassCaching"

  advanced_threat_protection_enabled = var.idpay_cdn_sa_advanced_threat_protection_enabled

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
      # Content-Security-Policy (in Report mode)
      {
        action = "Overwrite"
        name   = "Content-Security-Policy-Report-Only"
        value  = "default-src 'self'; object-src 'none'; connect-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ https://api-eu.mixpanel.com/track/; "
      },
      {
        action = "Append"
        name   = "Content-Security-Policy-Report-Only"
        value  = "script-src 'self'; style-src 'self' 'unsafe-inline' https://selfcare.pagopa.it/assets/font/selfhostedfonts.css; worker-src 'none'; font-src 'self' https://selfcare.pagopa.it/assets/font/; "
      },
      {
        action = "Append"
        name   = "Content-Security-Policy-Report-Only"
        value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.idpay_cdn.storage_primary_web_host} https://${var.env != "prod" ? "${var.env}." : ""}selfcare.pagopa.it https://selc${var.env_short}checkoutsa.z6.web.core.windows.net/institutions/ data:; "
      },
      {
        action = "Append"
        name   = "X-Content-Type-Options"
        value  = "nosniff"
      }
    ]
  }

  delivery_rule_rewrite = concat([{
    name  = "defaultApplication"
    order = 2
    conditions = [
      {
        condition_type   = "url_path_condition"
        operator         = "Equal"
        match_values     = ["/"]
        negate_condition = false
        transforms       = null
      }
    ]
    url_rewrite_action = {
      source_pattern          = "/"
      destination             = "/portale-enti/index.html"
      preserve_unmatched_path = false
    }
    }],
    local.spa
  )

  delivery_rule = [
    {
      name  = "robotsNoIndex"
      order = 3 + length(local.spa)

      // conditions
      url_path_conditions = [{
        operator         = "Equal"
        match_values     = length(var.robots_indexed_paths) > 0 ? var.robots_indexed_paths : ["dummy"]
        negate_condition = true
        transforms       = null
      }]
      cookies_conditions            = []
      device_conditions             = []
      http_version_conditions       = []
      post_arg_conditions           = []
      query_string_conditions       = []
      remote_address_conditions     = []
      request_body_conditions       = []
      request_header_conditions     = []
      request_method_conditions     = []
      request_scheme_conditions     = []
      request_uri_conditions        = []
      url_file_extension_conditions = []
      url_file_name_conditions      = []

      // actions
      modify_response_header_actions = [{
        action = "Overwrite"
        name   = "X-Robots-Tag"
        value  = "noindex, nofollow"
      }]
      cache_expiration_actions       = []
      cache_key_query_string_actions = []
      modify_request_header_actions  = []
      url_redirect_actions           = []
      url_rewrite_actions            = []
    },
    {
      name  = "microcomponentsNoCache"
      order = 4 + length(local.spa)

      // conditions
      url_path_conditions           = []
      cookies_conditions            = []
      device_conditions             = []
      http_version_conditions       = []
      post_arg_conditions           = []
      query_string_conditions       = []
      remote_address_conditions     = []
      request_body_conditions       = []
      request_header_conditions     = []
      request_method_conditions     = []
      request_scheme_conditions     = []
      request_uri_conditions        = []
      url_file_extension_conditions = []

      url_file_name_conditions = [{
        operator         = "Equal"
        match_values     = ["remoteEntry.js"]
        negate_condition = false
        transforms       = null
      }]

      // actions
      modify_response_header_actions = [{
        action = "Overwrite"
        name   = "Cache-Control"
        value  = "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
      }]
      cache_expiration_actions       = []
      cache_key_query_string_actions = []
      modify_request_header_actions  = []
      url_redirect_actions           = []
      url_rewrite_actions            = []
    }
  ]

  tags = var.tags
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "idpay_web_storage_access_key" {
  name         = "web-storage-access-key"
  value        = module.idpay_cdn.storage_primary_access_key
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "idpay_web_storage_connection_string" {
  name         = "web-storage-connection-string"
  value        = module.idpay_cdn.storage_primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "idpay_web_storage_blob_connection_string" {
  name         = "web-storage-blob-connection-string"
  value        = module.idpay_cdn.storage_primary_blob_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}


## CDN Welfare

resource "azurerm_resource_group" "rg_welfare" {
  name     = "${local.product}-welfare-rg"
  location = var.location
  tags     = var.tags
}


module "selfcare_welfare_cdn" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn?ref=v6.18.0"

  name                = "welfare-selfcare-${var.env_short}"
  prefix              = var.prefix
  resource_group_name = azurerm_resource_group.rg_welfare.name
  location            = var.location

  hostname              = "selfcare.${data.terraform_remote_state.core.outputs.dns_zone_welfare_name}"
  https_rewrite_enabled = true

  index_document     = "index.html"
  error_404_document = "not_found.html"

  dns_zone_name                = data.terraform_remote_state.core.outputs.dns_zone_welfare_name
  dns_zone_resource_group_name = data.terraform_remote_state.core.outputs.vnet_name_rg

  keyvault_resource_group_name = module.key_vault_idpay.resource_group_name
  keyvault_subscription_id     = data.azurerm_subscription.current.subscription_id
  keyvault_vault_name          = module.key_vault_idpay.name

  querystring_caching_behaviour      = "BypassCaching"
  advanced_threat_protection_enabled = var.idpay_cdn_sa_advanced_threat_protection_enabled

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
