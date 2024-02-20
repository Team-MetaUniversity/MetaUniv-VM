variable "aks_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The location of the AKS cluster."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster."
  type        = string
}

variable "node_count" {
  description = "The number of nodes for the AKS cluster."
  type        = number
}

variable "vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
}

variable "enable_node_public_ip" {
  description = "Should each node have a public IP address."
  type        = bool
}

variable "vnet_subnet_id" {
  description = "The subnet ID to which the AKS should be connected."
  type        = string
}

variable "admin_username" {
  description = "The admin username for the Linux profile."
  type        = string
}

variable "ssh_key_data" {
  description = "The public key data for the SSH key."
  type        = string
}

variable "gateway_id" {
  description = "ID of the Application Gateway."
  type        = string
}
