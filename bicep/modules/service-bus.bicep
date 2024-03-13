param location string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: 'sb-apl2003-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}
