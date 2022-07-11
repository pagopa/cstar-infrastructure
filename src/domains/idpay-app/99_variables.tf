# general

variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
  }
}

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

variable "location" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

variable "instance" {
  type        = string
  description = "One of beta, prod01, prod02"
}

variable "lock_enable" {
  type        = bool
  default     = false
  description = "Apply locks to block accedentaly deletions."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "terraform_remote_state_core" {
  type = object({
    resource_group_name  = string,
    storage_account_name = string,
    container_name       = string,
    key                  = string
  })
}

### External resources

variable "monitor_resource_group_name" {
  type        = string
  description = "Monitor resource group name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace is located in."
}

### Aks

variable "aks_name" {
  type        = string
  description = "AKS cluster name"
}

variable "aks_resource_group_name" {
  type        = string
  description = "AKS cluster resource name"

}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "ingress_load_balancer_hostname" {
  type = string
}

# DNS
variable "external_domain" {
  type        = string
  default     = "pagopa.it"
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  default     = "cstar"
  description = "The dns subdomain."
}

variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

#APP IO
variable "appio_timeout_sec" {
  type        = number
  description = "AppIo timeout (sec)"
  default     = 5
}

variable "reverse_proxy_be_io" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

