# Create a Resource Group    ( Run in Console )       
az group create --location centralindia --resource-group recogroup 

# Create a Azure Container Registry   ( Run in Console )   
az acr create --resource-group recogroup --name recoacr --sku Basic 

# Build the docker image   ( Run in Console )       
docker build -t reco .   

# Run Docker   ( Run in Console )    
docker run -p 8501:8501 reco

# Login into the Azure Container Registry ( Run in Console)     
az acr login -n recoacr   

# Login into the Azure Container Registry ( Run in Console)      

docker tag reco:latest recoacr.azurecr.io/reco:v1   

# Login into the Azure Container Registry ( Run in Console)    
docker push recoacr.azurecr.io/reco:v1

# Update the  Azure Container Registry ( Run in Console) 
az acr update -n recoacr --admin-enabled true       

# Get the password of the Azure CLI ( Run in Azure CLI )   
password=$(az acr credential show --name recoacr --query passwords[0].value --output tsv)

# Create the Azure Container ( Run in Azure CLI )        
az container create  --resource-group recogroup  \
--name reco --image recoacr.azurecr.io/reco:v1  \
--registry-login-server recoacr.azurecr.io \
--ip-address Public  --location centralindia  \
--registry-username recoacr \
--registry-password $password  \
--ports 8501 --dns-name-label recoapp   

# Navigate to http://recoapp.centralindia.azurecontainer.io:8501/

# Cleanup ( Run in Console)   
az group delete --resource-group recogroup


