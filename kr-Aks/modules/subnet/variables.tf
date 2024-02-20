variable "aks_subnet_name" {}
variable "resource_group_name" {}
variable "vnet_name" {}
variable "aks_subnet_prefixes" {
  type = list(string)
}
variable "appgw_subnet_name" {}
variable "appgw_subnet_prefixes" {
  type = list(string)
}
variable "dns_prefix" {}
