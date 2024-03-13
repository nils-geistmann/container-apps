param location string

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

output registryName string = containerRegistry.name
