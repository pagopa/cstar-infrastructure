# ------------------------------------------------------------------------------
# Generic variables definition.
# ------------------------------------------------------------------------------
variable "prefix" {
  type    = string
  default = "cstar"
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
  validation {
    condition = (
      length(var.env) <= 4
    )
    error_message = "Max length is 4 chars."
  }
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) <= 1
    )
    error_message = "Max length is 1 chars."
  }
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "location_short" {
  type    = string
  default = "weu"
}

#
# ACA Environment.
#
variable "aca_env_zones_enabled" {
  type        = bool
  default     = false
  description = "Enable zone redundancy for ACA environment."
}

# ------------------------------------------------------------------------------
# Subnet for ACA.
# ------------------------------------------------------------------------------
variable "aca_snet_cidr" {
  type = string
}

variable "cidr_mcshared_cae_subnet" {
  type = string
}
