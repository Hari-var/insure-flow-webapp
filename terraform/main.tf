
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate unique suffix for resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Data source to check if resource group exists
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
  
  # This will fail if RG doesn't exist, which is fine
  count = 0  # We'll create it anyway
}

# Always create the resource group (idempotent)
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  
  tags = var.common_tags
  
  lifecycle {
    # Prevent accidental deletion
    prevent_destroy = false
  }
}

resource "azurerm_service_plan" "main" {
  name                = "${var.app_name}-plan-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
  
  tags = var.common_tags
}

resource "azurerm_linux_web_app" "main" {
  name                = "${var.app_name}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  
  site_config {
    always_on = false
    
    application_stack {
      
      node_version = "18-lts"
      
    }
  }
  
  tags = var.common_tags
}
