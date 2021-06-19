az group create --location centralindia --resource-group recogroup 

az acr create --resource-group recogroup --name recoacr --sku Basic 

docker build -t reco .
docker run -p 8501:8501 reco

az acr login -n recoacr
docker tag reco:latest recoacr.azurecr.io/reco:v1
docker push recoacr.azurecr.io/reco:v1

az acr update -n recoacr --admin-enabled true
password=$(az acr credential show --name recoacr --query passwords[0].value --output tsv)

az container create  --resource-group recogroup  \
--name reco --image recoacr.azurecr.io/reco:v1  \
--registry-login-server recoacr.azurecr.io \
--ip-address Public  --location centralindia  \
--registry-username recoacr \
--registry-password $password  \
--ports 8501 --dns-name-label recoapp

##########################################################




