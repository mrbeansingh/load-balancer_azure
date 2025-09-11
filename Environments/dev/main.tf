module "resoure_group" {
  source   = "../../module/azurerm_resource_group"
  name     = "abhay-rg"
  location = "eastus"
}
module "virtul_network" {
  depends_on          = [module.resoure_group]
  source              = "../../module/azurerm_vnet"
  vnet_name           = "abhay-vnet"
  location            = "eastus"
  resource_group_name = "abhay-rg"
  address_space       = ["10.0.0.0/16"]

}





module "subnet1" {
  depends_on           = [module.virtul_network]
  source               = "../../module/azurerm_subnet"
  resource_group_name  = "abhay-rg"
  virtual_network_name = "abhay-vnet"
  subnet_name          = "AzureBastionSubnet"
  address_prefixes     = ["10.0.1.0/24"]

}
module "subnet2" {
  depends_on           = [module.virtul_network]
  source               = "../../module/azurerm_subnet"
  resource_group_name  = "abhay-rg"
  virtual_network_name = "abhay-vnet"
  subnet_name          = "subent-1"
  address_prefixes     = ["10.0.2.0/24"]

}
module "subnet3" {
  depends_on           = [module.virtul_network]
  source               = "../../module/azurerm_subnet"
  resource_group_name  = "abhay-rg"
  virtual_network_name = "abhay-vnet"
  subnet_name          = "subent-2"
  address_prefixes     = ["10.0.3.0/24"]

}

module "public_pip_bastion" {
  depends_on          = [module.resoure_group]
  source              = "../../module/azurerm_public_ip"
  public_ip_name      = "abhay-pip_bastion"
  location            = "eastus"
  resource_group_name = "abhay-rg"

}

module "public_pip_lb" {
  depends_on          = [module.resoure_group]
  source              = "../../module/azurerm_public_ip"
  public_ip_name      = "abhay-pip_lb"
  location            = "eastus"
  resource_group_name = "abhay-rg"

}

module "db" {
  depends_on          = [module.sqlserver]
  source              = "../../module/azurerm_sql_database"
  sqldb_name          = "abhaysqldb"
  sql_server_name     = "abhay-server"
  resource_group_name = "abhay-rg"

}
module "sqlserver" {
  depends_on                   = [module.resoure_group]
  source                       = "../../module/azurerm_sql_server"
  sqlserver_name               = "abhay-server"
  resource_group_name          = "abhay-rg"
  location                     = "westus"
  administrator_login          = "Nemuadmin"
  administrator_login_password = "Nemuuser@123"
}
module "keys" {
  depends_on          = [module.resoure_group]
  source              = "../../module/azurerm_key_valut"
  key_vault_name      = "abhay-keys"
  location            = "eastus"
  resource_group_name = "abhay-rg"

}
module "vm" {
  depends_on           = [module.resoure_group, module.subnet2, ]
  source               = "../../module/azurerm_virtual_machine"
  nic_name             = "abhay-nic"
  location             = "eastus"
  resource_group_name  = "abhay-rg"
  vm_name              = "abhay-vm"
  subnet_name          = "subent-1"
  virtual_network_name = "abhay-vnet"

}

module "vm1" {
  depends_on           = [module.resoure_group, module.subnet2, ]
  source               = "../../module/azurerm_virtual_machine"
  nic_name             = "singh-nic"
  location             = "eastus"
  resource_group_name  = "abhay-rg"
  vm_name              = "abhay-vm-2"
  subnet_name          = "subent-2"
  virtual_network_name = "abhay-vnet"

}

module "bastion_host" {
  depends_on            = [module.subnet1]
  source                = "../../module/azurerm_bastion"
  location              = "eastus"
  resource_group_name   = "abhay-rg"
  ip_configuration_name = "abhay-bastion"
  subnet_name           = "AzureBastionSubnet"
  virtual_network_name  = "abhay-vnet"
  public_ip_name        = "abhay-pip_bastion"
  bastion_name          = "abhay-bastion_host"

}

module "lb" {
  depends_on = [ module.public_pip_lb ]
  source                         = "../../module/azure_load_balancer"
  resource_group_name            = "abhay-rg"
  lb_name                        = "abhay-lb"
  location                       = "eastus"
  frontend_ip_configuration_name = "lb_frontend"
  backend_lb_pool_name           = "lb_backend"
  lb_rule_name                   = "lb_rule"
  public_ip_name                 = "lb_public_ip"
  lb_prob_name                   = "lb_prob"
}
module "add_vm-1" {
  depends_on = [ module.lb ]
  source                = "../../module/azurerm_vm_association"
  bap_name              = "backend-pool-abhay"
  nic_name              = "singh-nic"
  lb_name               = "abhay-lb"
  resource_group_name   = "abhay-rg"
  ip_configuration_name = "internal"


}
module "add_vm-2" {
  depends_on = [ module.lb ]
  source                = "../../module/azurerm_vm_association"
  bap_name              = "backend-pool-abhay"
  nic_name              = "abhay-nic"
  lb_name               = "abhay-lb"
  resource_group_name   = "abhay-rg"
  ip_configuration_name = "internal"


}







