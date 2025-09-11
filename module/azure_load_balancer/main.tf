
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.pip_lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_lb_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.backend_lb_pool_name
}

resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.lb_prob_name
  port            = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_lb_pool.id]
  probe_id = azurerm_lb_probe.example.id
}





