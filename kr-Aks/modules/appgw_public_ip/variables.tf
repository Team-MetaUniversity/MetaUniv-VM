variable "name" {
  description = "The name of the Application Gateway public IP."
  type        = string
}

variable "location" {
  description = "The location of the Application Gateway public IP."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "allocation_method" {
  description = "The allocation method for the public IP."
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the public IP."
  default     = "Standard"
}
