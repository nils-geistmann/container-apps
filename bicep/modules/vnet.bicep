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
        name: 'ACASubnet'
        properties: {
          addressPrefix: '10.0.4.0/23'
        }
      }
    ]
  }
}

resource peSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: 'PESubnet'
  parent: vnet
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

output peSubnetId string = peSubnet.id
output vNetId string = vnet.id
