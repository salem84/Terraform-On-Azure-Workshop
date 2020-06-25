# From Azure Shell
param([Parameter(Mandatory)][string] $aksHostName)
helm upgrade --install tailwindtraders-web ./Deploy/helm/web -f ./Deploy/helm/gvalues.yaml -f ./Deploy/helm/values.b2c.yaml  --set ingress.hosts={$aksHostName}  --set ingress.protocol=http --set ingress.tls[0].hosts={$aksHostName} --set image.repository=giorgiolasala/tailwindtradersweb --set image.tag=latest