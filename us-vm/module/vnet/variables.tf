variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vnet_location" {
  description = "The location of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group the virtual network is associated with"
  type        = string
}

variable "location" {
  description = "The Azure region where the virtual network will be created"
  type        = string
}