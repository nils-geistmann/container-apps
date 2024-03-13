param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  location: location
  name: 'VNET1'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'PESubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'ACASubnet'
        properties: {
          addressPrefix: '10.0.4.0/23'
        }
      }
    ]
  }
}

output vnet object = vnet
