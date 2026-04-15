
variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app1784jnv4"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,60}$", var.app_name))
    error_message = "App name must be 1-60 characters and contain only letters, numbers, and hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "my-app1784jnv4-rg"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9._()-]{1,90}$", var.resource_group_name))
    error_message = "Resource group name must be 1-90 characters."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
  
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", "westus3",
      "centralus", "northcentralus", "southcentralus",
      "westcentralus", "canadacentral", "canadaeast",
      "brazilsouth", "northeurope", "westeurope",
      "uksouth", "ukwest", "francecentral", "germanywestcentral",
      "norwayeast", "switzerlandnorth", "swedencentral",
      "australiaeast", "australiasoutheast", "southeastasia",
      "eastasia", "japaneast", "japanwest", "koreacentral",
      "southindia", "centralindia", "westindia"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Application = "my-app1784jnv4"
    ManagedBy   = "Terraform"
    CreatedBy   = "DevOps-Agent"
  }
}
