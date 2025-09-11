data "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.resource_group_name
}
data "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
}

data "azurerm_lb_backend_address_pool" "pool" {
  name            = var.bap_name
  loadbalancer_id = data.azurerm_lb.lb.id
}