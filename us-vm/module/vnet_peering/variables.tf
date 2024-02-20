variable "peering_name" {
  description = "The name of the VNet peering"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network initiating the peering"
  type        = string
}

variable "remote_virtual_network_id" {
  description = "The ID of the remote virtual network"
  type        = string
}

variable "allow_virtual_network_access" {
  description = "Whether the VMs in the linked virtual networks can access each other"
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Whether forwarded traffic from VMs in the remote VNet will be allowed/disallowed"
  type        = bool
  default     = true
}
