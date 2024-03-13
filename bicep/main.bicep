targetScope = 'subscription'

var resourceGroupName = 'RG1'

@allowed(
  [ 'centralus' ]
)
param resourceGroupLocation string

module rg 'modules/resource-group.bicep' = {
  name: 'resource-group-module'
  params: {
    resourceGroupName: resourceGroupName
    resourceGroupLocation: resourceGroupLocation
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet-module'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: rg.outputs.location
  }
}

module serviceBus 'modules/service-bus.bicep' = {
  name: 'service-bus-module'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: rg.outputs.location
  }
}

module containerRegistry 'modules/container-registry.bicep' = {
  name: 'container-registry-module'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: rg.outputs.location
    vnetId: vnet.outputs.vNetId
    privateEndpointSubnetId: vnet.outputs.peSubnetId
  }
}

output acrName string = containerRegistry.outputs.registryName
