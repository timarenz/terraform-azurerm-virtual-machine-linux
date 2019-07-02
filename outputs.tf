output "private_ip" {
  value = azurerm_network_interface.main.private_ip_address
}

output "public_ip" {
  value = var.public_ip ? azurerm_public_ip.main[0].ip_address : null
}

output "id" {
  value = azurerm_virtual_machine.main.id
}

output "network_interface_id" {
  value = azurerm_network_interface.main.id
}
