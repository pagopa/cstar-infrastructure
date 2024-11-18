# ------------------------------------------------------------------------------
# Redis Cache.
# ------------------------------------------------------------------------------
variable "redis_name" {
  type = string
}

variable "redis_resource_group_name" {
  type = string
}

data "azurerm_redis_cache" "core" {
  name                = var.redis_name
  resource_group_name = var.redis_resource_group_name
}