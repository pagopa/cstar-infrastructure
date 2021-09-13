variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "name" {
  type = string
}

variable "sku_name" {
  type        = string
  description = "SKU Name of the App GW"
}

variable "sku_tier" {
  type        = string
  description = "SKU tier of the App GW"
}

# Networkig

variable "subnet_id" {
  type        = string
  description = "Subnet dedicated to the app gateway"
}

variable "public_ip_id" {
  type        = string
  description = "Public IP"
}

variable "backends" {
  type = map(object({
    protocol     = string
    host         = string
    port         = number
    ip_addresses = list(string)
    probe        = string
    probe_name   = string
  }))
}

variable "listeners" {
  type = map(object({
    protocol         = string
    host             = string
    port             = number
    ssl_profile_name = string
    certificate = object({
      name = string
      id   = string
    })
  }))
}

variable "ssl_profiles" {
  type = list(object({
    name                             = string
    trusted_client_certificate_names = list(string)
    verify_client_cert_issuer_dn     = bool

    ssl_policy = object({
      disabled_protocols   = list(string)
      policy_type          = string
      policy_name          = string
      cipher_suites        = list(string)
      min_protocol_version = string
    })
  }))
  default = []
}

variable "trusted_client_certificates" {
  type = list(object({
    name         = string
    key_vault_id = string
  }))
}

variable "routes" {
  type = map(object({
    listener = string
    backend  = string
  }))
}

# TLS

variable "identity_ids" {
  type = list(string)
}

# Scaling

variable "app_gateway_max_capacity" {
  type = string
}

variable "app_gateway_min_capacity" {
  type = string
}

variable "tags" {
  type = map(any)
}
