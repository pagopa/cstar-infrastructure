variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "cstar"
}

variable "env_short" {
  type = string
}


# Network
variable "cidr_vnet" {
  type        = list(string)
  description = "Virtual network address space."
}

variable "cidr_subnet_db" {
  type        = list(string)
  description = "Database network address space."
}

variable "cidr_subnet_k8s" {
  type        = list(string)
  description = "Subnet cluster kubernetes."
}

## Monitor
variable "law_sku" {
  type        = string
  description = "Sku of the Log Analytics Workspace"
  default     = "PerGB2018"
}

variable "law_retention_in_days" {
  type        = number
  description = "The workspace data retention in days"
  default     = 30
}

variable "law_daily_quota_gb" {
  type        = number
  description = "The workspace daily quota for ingestion in GB."
  default     = -1
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}