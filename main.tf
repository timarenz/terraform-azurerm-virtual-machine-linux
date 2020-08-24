locals {
  common_tags = {
    environment = var.environment_name
    owner       = var.owner_name
    ttl         = var.ttl
  }
  all_tags = merge(local.common_tags, var.tags == null ? {} : var.tags)
}

data "azurerm_platform_image" "ubuntu" {
  location  = var.region
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "16.04-LTS"
}

resource "azurerm_public_ip" "main" {
  count               = var.public_ip ? 1 : 0
  name                = "${var.environment_name}-${var.vm_name}-public-ip"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = local.all_tags
}

# resource "azurerm_network_security_group" "main" {
#   name                = "${var.environment_name}-${var.vm_name}-nsg"
#   location            = var.region
#   resource_group_name = var.resource_group_name

#   tags = local.all_tags
# }

# resource "azurerm_network_security_rule" "ssh" {
#   name                        = "${var.environment_name}-${var.vm_name}-nsr-ssh"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_address_prefix       = "*"
#   source_port_range           = "*"
#   destination_address_prefix  = "*"
#   destination_port_range      = "5985"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.main.name
# }

resource "azurerm_network_interface" "main" {
  name                = "${var.environment_name}-${var.vm_name}-interface"
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.environment_name}-${var.vm_name}-private-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_address : null
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.main[0].id : null
  }

  tags = local.all_tags
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment_name}-${var.vm_name}"
  location              = var.region
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = data.azurerm_platform_image.ubuntu.publisher
    offer     = data.azurerm_platform_image.ubuntu.offer
    sku       = data.azurerm_platform_image.ubuntu.sku
    version   = data.azurerm_platform_image.ubuntu.version
  }

  storage_os_disk {
    name          = "${var.environment_name}-${var.vm_name}-osdisk"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  tags = local.all_tags
}
