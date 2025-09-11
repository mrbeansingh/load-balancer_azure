terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }
  backend "azurerm" {
     resource_group_name   = "abhay-rg"
    storage_account_name  = "abhaystoragesingh"
    container_name        = "abhay-container"
    key                   = "terraform.tfstate"
  }
}
    
 


provider "azurerm" {
  features {}
  subscription_id = "c751b003-03b2-41f7-8579-5c1a60f11ac2"
}

