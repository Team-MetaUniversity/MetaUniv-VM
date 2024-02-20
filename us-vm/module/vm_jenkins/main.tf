data "template_file" "linux_vm_cloud_init" {
  template = file(var.custom_data_file)
}

resource "azurerm_linux_virtual_machine" "vm_jenkins" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  size                  = var.vm_size
  custom_data           = base64encode(data.template_file.linux_vm_cloud_init.rendered)
  
  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "${var.name}-vm"
  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }
}
