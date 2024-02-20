variable "appgw_name" {
  description = "The name of the Application Gateway"
  type        = string
}

variable "location" {
  description = "The location of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the Application Gateway"
  type        = string
}

variable "public_ip_address_id" {
  description = "The ID of the public IP address for the frontend IP configuration"
  type        = string
}

variable "backend_address_pool_name" {
  description = "The name of the backend address pool"
  type        = string
}

variable "http_setting_name" {
  description = "The name of the backend HTTP settings"
  type        = string
}

variable "listener_name" {
  description = "The name of the HTTP listener"
  type        = string
}

variable "request_routing_rule_name" {
  description = "The name of the request routing rule"
  type        = string
}
