terraform {
  required_version = ">= 0.15.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }    
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_azgroup" {
    name     = "myResourceGroup"
    location = "eastus"
}

# Create virtual network
resource "azurerm_virtual_network" "terraform_aznetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.terraform_azgroup.name
}

# Create subnet
resource "azurerm_subnet" "terraform_azsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.terraform_azgroup.name
    virtual_network_name = azurerm_virtual_network.terraform_aznetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "terraform_aznsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.terraform_azgroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  }

# Create network interface
resource "azurerm_network_interface" "terraform_aznic" {
    name                      = "myNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.terraform_azgroup.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.terraform_azsubnet.id
        private_ip_address_allocation = "Dynamic"        
    }
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "terraform_azvm" {
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.terraform_azgroup.name
    network_interface_ids = [azurerm_network_interface.terraform_aznic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

  source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

  computer_name  = "azureVM2"
  admin_username = "-----"
  admin_password = "-----"
  disable_password_authentication = "false"

}

