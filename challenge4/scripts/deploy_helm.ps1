# From Azure Shell
param([Parameter(Mandatory)][string] $aksHostName = "challenge-aks",
    [Parameter(Mandatory)][string] $rg = "RG_azchallenge-4"
)

az aks get-credentials --name $aksHostName --resource-group $rg

# Required in chart (error seen with kubectl get events -w)
kubectl create serviceaccount ttsa

helm upgrade --install tailwindtraders-web ./Deploy/helm/web -f ./Deploy/helm/gvalues.yaml -f ./Deploy/helm/values.b2c.yaml  --set ingress.hosts[0]=$aksHostName  --set ingress.protocol=http --set image.repository=giorgiolasala/tailwindtradersweb --set image.tag=latest


