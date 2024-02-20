variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group the subnet is associated with"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network the subnet is part of"
  type        = string
}

variable "address_prefixes" {
  description = "The address prefix to use for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
