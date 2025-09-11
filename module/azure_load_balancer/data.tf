
data "azurerm_public_ip" "pip_lb" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}
