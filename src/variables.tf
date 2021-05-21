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

variable "cidr_subnet_jumpbox" {
  type        = list(string)
  description = "Jumpbox subnet address space."
}

## AKS

variable "cidr_subnet_k8s" {
  type        = list(string)
  description = "Subnet cluster kubernetes."
}

variable "aks_availability_zones" {
  type        = list(number)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = []
}

variable "kubernetes_version" {
  type    = string
  default = null
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


# key vault
variable "ad_key_vault_group_object_id" {
  type        = string
  description = "Id active directory group allowed to query the keyault."
  default     = null
}

# apim 

variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null

}

variable "apim_publisher_name" {
  type = string
}

variable "apim_publisher_email" {
  type = string
}

variable "apim_notification_sender_email" {
  type = string
}

variable "apim_sku" {
  type = string
}

# Azure DevOps Agent
variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

variable "azdoa_scaleset_li_public_key" {
  type        = string
  description = "Azure DevOps agent public key."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}