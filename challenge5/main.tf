provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "challenge" {
  name     = "RG_${var.prefix}"
  location = "North Europe"
}