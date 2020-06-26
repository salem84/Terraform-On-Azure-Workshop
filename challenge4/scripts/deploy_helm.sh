#!/bin/bash

# From Azure Shell
AKSHOSTNAME = "challenge-aks"
RG = "RG_azchallenge-4"

az aks get-credentials --name $AKSHOSTNAME --resource-group $RG

# Required in chart (error seen with kubectl get events -w)
kubectl create serviceaccount ttsa

helm upgrade --install tailwindtraders-web ./Deploy/helm/web -f ./Deploy/helm/gvalues.yaml -f ./Deploy/helm/values.b2c.yaml  --set ingress.hosts={$AKSHOSTNAME}  --set ingress.protocol=http --set image.repository=giorgiolasala/tailwindtradersweb --set image.tag=latest


