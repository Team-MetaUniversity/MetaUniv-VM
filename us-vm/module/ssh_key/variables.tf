variable "prefix" {
  description = "Prefix for the SSH key name"
  type        = string
  default     = "ssh"
}

variable "location" {
  description = "The location where the SSH key will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "length" {
  description = "The number of words in the generated pet name, increases uniqueness"
  type        = number
  default     = 3
}
