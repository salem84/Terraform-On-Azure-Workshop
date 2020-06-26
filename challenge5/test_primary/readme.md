https://learn.hashicorp.com/consul/kubernetes/mesh-gateways
https://www.hashicorp.com/blog/connecting-kubernetes-clusters-with-hashicorp-consul-wan-federation/


Consul UI (8500 - 8501)
kubectl port-forward service/consul-server 8500:8500

kubectl get secrets

kubectl get pod --selector=app=consul -o name
kubectl get pod --selector=component=mesh-gateway -o name

kubectl exec --stdin --tty consul-server-0 -- /bin/sh
kubectl exec statefulset/consul-server -- consul members -wan
