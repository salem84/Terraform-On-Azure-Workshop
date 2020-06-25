# Previously do docker login (I'm using dockerhub directly)

cd Source/Tailwind.Traders.Web

# Build image locally
docker build -t tailwindtradersweb .

# Tagging
docker tag tailwindtradersweb giorgiolasala/tailwindtradersweb

# Push
docker push giorgiolasala/tailwindtradersweb