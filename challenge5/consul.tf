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
      #target_port = 8302 # Serf WAN port (seen from output screenshot)
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
    caCert: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM3akNDQXBTZ0F3SUJBZ0lSQU9MWE9YNThIbFcwRmNRdlArakYycHd3Q2dZSUtvWkl6ajBFQXdJd2dia3gKQ3pBSkJnTlZCQVlUQWxWVE1Rc3dDUVlEVlFRSUV3SkRRVEVXTUJRR0ExVUVCeE1OVTJGdUlFWnlZVzVqYVhOagpiekVhTUJnR0ExVUVDUk1STVRBeElGTmxZMjl1WkNCVGRISmxaWFF4RGpBTUJnTlZCQkVUQlRrME1UQTFNUmN3CkZRWURWUVFLRXc1SVlYTm9hVU52Y25BZ1NXNWpMakZBTUQ0R0ExVUVBeE0zUTI5dWMzVnNJRUZuWlc1MElFTkIKSURNd01UVXlNekF6TmprNU1EUTRORFkzTXpnM05EUTRNemM0T1RJeU1EUTBOREl6TWpNME9EQWVGdzB5TURBMgpNalV3T1RJek1EZGFGdzB5TlRBMk1qUXdPVEl6TURkYU1JRzVNUXN3Q1FZRFZRUUdFd0pWVXpFTE1Ba0dBMVVFCkNCTUNRMEV4RmpBVUJnTlZCQWNURFZOaGJpQkdjbUZ1WTJselkyOHhHakFZQmdOVkJBa1RFVEV3TVNCVFpXTnYKYm1RZ1UzUnlaV1YwTVE0d0RBWURWUVFSRXdVNU5ERXdOVEVYTUJVR0ExVUVDaE1PU0dGemFHbERiM0p3SUVsdQpZeTR4UURBK0JnTlZCQU1UTjBOdmJuTjFiQ0JCWjJWdWRDQkRRU0F6TURFMU1qTXdNelk1T1RBME9EUTJOek00Ck56UTBPRE0zT0RreU1qQTBORFF5TXpJek5EZ3dXVEFUQmdjcWhrak9QUUlCQmdncWhrak9QUU1CQndOQ0FBUmoKYkI1QUlERGJKcUljZ2xSZnhWTGxpVDA5b3pHUnkrY3o4Y2RWaFFFaXJBRjBPWUtoUXJmUjJodHZGYjJlcWhvSApZcVBQanBLRi90cWhsNmxteHdMSm8zc3dlVEFPQmdOVkhROEJBZjhFQkFNQ0FZWXdEd1lEVlIwVEFRSC9CQVV3CkF3RUIvekFwQmdOVkhRNEVJZ1FncW1mNkkxbHg1ZVFYV0t5RkZvL2dVRWxFZnYzMmE1SUowN2gvMUZmeHNDSXcKS3dZRFZSMGpCQ1F3SW9BZ3FtZjZJMWx4NWVRWFdLeUZGby9nVUVsRWZ2MzJhNUlKMDdoLzFGZnhzQ0l3Q2dZSQpLb1pJemowRUF3SURTQUF3UlFJZ0tieTdBOVE4elhTaTFTak9mdit5eFFEK3RZbHpHZnhBOFBLVkhneTQ4YUVDCklRRFl2bk45ZmVvZkplRUhES0VaTmdFa1VuRHJpZnMyeGsxNnlFUmF0V0Uwd1E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
    caKey: "LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSUlkcGQ0WUJqZTFPaXE0YzBYaFU0VWxRcmpOVHF5enFLQ2UxUTVNRGxHZHpvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFWTJ3ZVFDQXcyeWFpSElKVVg4VlM1WWs5UGFNeGtjdm5NL0hIVllVQklxd0JkRG1Db1VLMwowZG9iYnhXOW5xb2FCMktqejQ2U2hmN2FvWmVwWnNjQ3lRPT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo="
    gossipEncryptionKey: "eGNJR0NVVXJvWHNsVUs0dUwrUHI2eUFVYU5uS1ZKekhPdXVyeFUrTkN1TT0="
    replicationToken: "NzliZmViMjgtNDM1ZS1hMGE1LTEwNWEtY2Q5OWVkYWNkZmVh"
    serverConfigJSON: "eyJwcmltYXJ5X2RhdGFjZW50ZXIiOiJkYzEiLCJwcmltYXJ5X2dhdGV3YXlzIjpbIjUxLjEzNy4yMTQuMjQ2OjQ0MyJdfQ=="
    # consul-federation = file("assets/consul-federation.yaml")
  }
}


output "instance_ip_addr" {
  value = azurerm_public_ip.consul_public.ip_address
}