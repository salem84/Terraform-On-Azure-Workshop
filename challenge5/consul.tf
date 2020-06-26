# Public IP for Load Balancer Consul
resource "azurerm_public_ip" "consul_public" {
  name                = "consulip"
  location            = azurerm_resource_group.challenge.location
  resource_group_name = azurerm_kubernetes_cluster.aks_challenge.node_resource_group
  allocation_method   = "Static"
}


# Kubernetes Service MeshGateway
resource "kubernetes_service" "service_consul" {
  metadata {
    name = "consul-loadbalancer"
  }
  spec {
    selector = {
      app       = "consul"
      component = "mesh-gateway"
    }
    load_balancer_ip = azurerm_public_ip.consul_public.ip_address
    port {
      port        = 80
      target_port = 8302 # Serf WAN port (seen from output screenshot)
    }
    type = "LoadBalancer"
  }
}

# Helm Consul
resource "helm_release" "consul" {
  name       = "k8s-salem84-consul"
  #repository = "https://helm.releases.hashicorp.com"
  chart      = "hashicorp/consul"

  values = [
    "${file("assets/config-consul.yaml")}"
  ]
}


# resource "helm_release" "mydatabase" {
#   name  = "mydatabase"
#   chart = "stable/mariadb"

#   set {
#     name  = "mariadbUser"
#     value = "foo"
#   }

#   set {
#     name  = "mariadbPassword"
#     value = "qux"
#   }
# }

resource "kubernetes_secret" "consul-federation-secret" {
  metadata {
    name = "consul-federation"
  }

  data = {
    caCert: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    caKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    gossipEncryptionKey: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    replicationToken: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    serverConfigJSON: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    # consul-federation = file("assets/consul-federation.yaml")
  }
}


output "instance_ip_addr" {
  value = azurerm_public_ip.consul_public.ip_address
}