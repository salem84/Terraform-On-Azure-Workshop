provider "azurerm" {
  features {}
}

variable "prefix" {
  default = "azchallenge-1"
}

resource "azurerm_resource_group" "challenge" {
  name     = "RG_${var.prefix}"
  location = "North Europe"
}

resource "azurerm_app_service_plan" "challenge" {
  name                = "${var.prefix}-appserviceplan"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "challenge" {
  name                = "${var.prefix}-app-service"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name
  app_service_plan_id = azurerm_app_service_plan.challenge.id

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2",
    "ApiUrl" = "",
    "ApiUrlShoppingCart" = "",
    "MongoConnectionString" = "",
    "SqlConnectionString" = "",
    "productImagesUrl" = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail",
    "Personalizer__ApiKey" = "",
    "Personalizer__Endpoint" = ""
  }
}
	
	
	
	