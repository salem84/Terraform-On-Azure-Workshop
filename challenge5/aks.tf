resource "azurerm_kubernetes_cluster" "aks_challenge" {
  name                = "giorgiolasala-aks"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_resource_group.challenge.name
  dns_prefix          = "${var.prefix}-giorgiolasala-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

#   identity {
#     type = "SystemAssigned"
#   }

  service_principal {
    client_id     = var.sp_client_id
    client_secret = var.sp_client_secret
  }

  role_based_access_control {
    enabled = true
  }
}