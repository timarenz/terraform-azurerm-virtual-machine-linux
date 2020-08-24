variable "environment_name" {
  type = string
}

variable "owner_name" {
  type    = string
  default = null
}

variable "ttl" {
  type    = number
  default = 48
}

variable "region" {
  type    = string
  default = "West Europe"
}

variable "resource_group_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "public_ip" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

# variable "network_security_group_id" {
#   type    = string
#   default = null
# }

variable "tags" {
  type    = map
  default = null
}

variable "private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
}

variable "private_ip_address" {
  type    = string
  default = null
}
