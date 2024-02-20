variable "prefix" {
  description = "Prefix for the SSH key name, to ensure uniqueness"
  type        = string
  default     = "ssh"
}

variable "location" {
  description = "The Azure region where the SSH key will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the SSH key will be created"
  type        = string
}

variable "separator" {
  description = "Separator for the random_pet name generation"
  type        = string
  default     = ""
}
