variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet within the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the virtual network and subnet."
  type        = string
}

variable "lb_name" {
  description = "The name of the Load Balancer."
  type        = string
}

variable "location" {
  description = "The location of the Load Balancer."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "public_ip_address_id" {
  description = "The ID of the public IP address for the Load Balancer."
  type        = string
}

variable "backend_pool_name" {
  description = "The name of the backend address pool."
  type        = string
}

variable "vmss_name" {
    type        = string
}
variable "resource_group_name" {
    type        = string
}
variable "location" {
    type        = string
}
variable "sku" {
    type        = string
}
variable "instances" {
    type        = string
}
variable "admin_username" {
    type        = string
}
variable "ssh_public_key" {
    type        = string
}
variable "subnet_id" {
    type        = string
}
