param location string

var acrPullDefinitionId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

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

output registryName string = containerRegistry.name
