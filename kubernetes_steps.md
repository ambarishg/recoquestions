az group create --location centralindia --resource-group recogroup 

az acr create --resource-group recogroup --name recoacr --sku Basic 

docker build -t reco .
docker run -p 8501:8501 reco

az acr login -n recoacr
docker tag reco:latest recoacr.azurecr.io/reco:v1
docker push recoacr.azurecr.io/reco:v1

az aks create \
    --resource-group recogroup \
    --name recoAKSCluster \
    --node-count 1 \
    --generate-ssh-keys \
    --attach-acr recoacr

az aks install-cli

az aks get-credentials --resource-group recogroup --name recoAKSCluster

kubectl get nodes

kubectl apply -f reco.yaml

kubectl get service reco --watch


40.80.92.154:8501

az group delete --resource-group recogroup