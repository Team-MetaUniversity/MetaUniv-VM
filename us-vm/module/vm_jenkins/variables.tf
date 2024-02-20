variable "name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "location" {
  description = "Azure region where the VM will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "network_interface_ids" {
  description = "List of network interface IDs to attach to the VM"
  type        = list(string)
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key for the VM admin user"
  type        = string
}

variable "custom_data_file" {
  description = "Path to the cloud-init script file"
  type        = string
  default     = "userdata.sh"
}

variable "storage_account_uri" {
  description = "URI for the storage account to be used for boot diagnostics"
  type        = string
}
