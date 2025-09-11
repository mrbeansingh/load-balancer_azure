resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = data.azurerm_subnet.subnet_id.id
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}


