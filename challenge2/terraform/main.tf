provider "azurerm" {
  features {}
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

resource "azurerm_sql_server" "db_server" {
  name                         = "${var.prefix}-sql"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name
  version                      = "12.0"
  administrator_login          = var.db_user
  administrator_login_password = var.db_password
}

resource "azurerm_sql_firewall_rule" "db_server_fw" {
  name                = "AllowAccessAzureService"
  resource_group_name = azurerm_resource_group.challenge.name
  server_name         = azurerm_sql_server.db_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "db_instance" {
  name                = "${var.prefix}-db"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name
  server_name         = azurerm_sql_server.db_server.name
}
	

resource "azurerm_container_group" "mongo_aci" {
  name                = "${var.prefix}-mongo-aci"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name
  ip_address_type     = "public"
  dns_name_label      = "${var.prefix}-mongo-aci"
  os_type             = "linux"

  container {
    name   = "mongo-aci"
    image  = "mongo:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 27017
      protocol = "TCP"
    }

    secure_environment_variables = {
      MONGO_INITDB_ROOT_USERNAME = var.db_user
      MONGO_INITDB_ROOT_PASSWORD = var.db_password
    }
  }
}
	
resource "azurerm_app_service" "challenge" {
  name                = "${var.prefix}-app-service"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name
  app_service_plan_id = azurerm_app_service_plan.challenge.id

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2",
    "ApiUrl" = "/api/v1",
    "ApiUrlShoppingCart" = "/api/v1",
    "MongoConnectionString" = "mongodb://${var.db_user}:${var.db_password}@${azurerm_container_group.mongo_aci.fqdn}:27017",
    "SqlConnectionString" = "Server=tcp:${azurerm_sql_server.db_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db_instance.name};Persist Security Info=False;User ID=${var.db_user};Password=${var.db_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    "productImagesUrl" = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail",
    "Personalizer__ApiKey" = "",
    "Personalizer__Endpoint" = ""
  }
}

output "fqdn" {
  value = azurerm_container_group.mongo_aci.fqdn
}