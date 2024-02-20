variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

variable "location" {
  description = "The location of the network interface"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "public_ip_address_id" {
  description = "The ID of the public IP address"
  type        = string
  default     = ""
}
