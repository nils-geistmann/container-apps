# these commands need to be executed after each (re)creation of the devcontainer
az extension add --name containerapp --upgrade
az config set bicep.use_binary_from_path=True

# this command deploys the required resources - make sure to az login first
az deployment sub create -f bicep/main.bicep -l centralus

# to login to the Azure Container Registry use the following command and complete the registry name
az acr login -n acrapl2003<>

# build the docker image locally
docker build --tag aspnetcorecontainer:latest -f webapi/Dockerfile .

# tag the image with the correct registry name and push the image
docker image tag aspnetcorecontainer:latest acrapl2003<>.azurecr.io/aspnetcorecontainer:latest