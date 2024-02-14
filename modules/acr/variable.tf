variable "acr_name" {
  description = "The name of the Azure Container Registry."
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "location" {
  description = "The location of the ACR."
}

variable "sku" {
  description = "The SKU of the ACR."
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Flag to enable admin user."
  default     = false
}

variable "aks_kubelet_identity_object_id" {
  description = "The object ID of the AKS cluster's kubelet identity."
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
}

variable "aks_resource_group_name" {
  description = "The name of the resource group containing the AKS cluster."
}
