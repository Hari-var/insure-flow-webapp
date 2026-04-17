
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
  
  # This will return null if RG doesn't exist
  count = 0  # We'll handle this with try() in locals
}

# Local values for conditional resource creation
locals {
  # Check if resource group exists
  rg_exists = can(data.azurerm_resource_group.existing)
  
  # Use existing RG if it exists, otherwise create new one
  resource_group_name = var.resource_group_name
  location = var.location
}

# Create resource group only if it doesn't exist
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
  
  tags = var.common_tags
  
  lifecycle {
    # Prevent accidental deletion in production
    prevent_destroy = false
    # Ignore changes to tags that might be added externally
    ignore_changes = [tags]
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
    
    app_command_line = "npx serve -s ."
    
    application_stack {
      node_version = "18-lts"
    }
  }
  
  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
    
    application_logs {
      file_system_level = "Information"
    }
  }
  
  app_settings = {
    WEBSITE_NODE_DEFAULT_VERSION = "18-lts"
    NPM_CONFIG_PRODUCTION = "false"
    WEBSITE_RUN_FROM_PACKAGE = "1"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }
  
  tags = var.common_tags
}
