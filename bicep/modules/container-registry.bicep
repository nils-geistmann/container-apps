param location string
param vnetId string
param privateEndpointSubnetId string

var acrPullDefinitionId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
var privateEndpointName = 'pe-acr-apl2003'

@description('This is the built-in Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource acrPullRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: acrPullDefinitionId
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'acrapl2003${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    adminUserEnabled: true
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'uai-apl2003'
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.id, acrPullDefinitionId)
  scope: containerRegistry
  properties: {
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: acrPullRoleDefinition.id
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: containerRegistry.id
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink${environment().suffixes.acrLoginServer}'
  location: 'global'
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateDnsZone.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}

resource pvtEndpointDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      { name: 'privatelink-azurecr-io'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'pe-acr-apl2003-nic'
  location: location
  tags: {
    displayName: 'pe-acr-apl2003-nic'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'pe-acr-apl2003-ipconfig.${guid('pe-acr-apl2003-nic')}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: privateEndpointSubnetId
          }
        }
      }
    ]
  }
}

output registryName string = containerRegistry.name
