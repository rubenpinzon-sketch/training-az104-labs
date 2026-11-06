output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_id" {
  description = "Resource ID of the VM"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg.name
}

output "rdp_connection" {
  description = "RDP connection string"
  value       = "mstsc /v:${azurerm_public_ip.pip.ip_address}"
}
