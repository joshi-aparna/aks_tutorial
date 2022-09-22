
param aksName string

@description('Specifies the location for the networking resources.')
param location string = 'eastus2'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: aksName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/8'
      ]
    }
    subnets: [
      {
        name: '${aksName}-subnet1'
        properties: {
          addressPrefix: '10.240.0.0/16'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}


output defaultSubnetId string = virtualNetwork.properties.subnets[0].id
