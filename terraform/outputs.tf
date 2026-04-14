
output "app_url" {
  description = "Application URL"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.main.id
}

output "app_name" {
  description = "Application name with suffix"
  value       = azurerm_linux_web_app.main.name
}

output "service_plan_name" {
  description = "Service plan name"
  value       = azurerm_service_plan.main.name
}
