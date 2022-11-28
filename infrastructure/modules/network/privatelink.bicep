param region string 
param privateLinkName string
param managedResourceGroupName string
param virtualNetworkName string

resource loadbalancer 'Microsoft.Network/loadBalancers@2022-05-01' existing = {
 scope: resourceGroup(managedResourceGroupName)
 name : 'kubernetes-internal'
}



resource privateLink 'Microsoft.Network/privateLinkServices@2022-05-01' = {
  name : privateLinkName
  location : region
  properties: {
    visibility: {
      subscriptions: [ 
        '*' 
      ]
    }
    enableProxyProtocol: false
    loadBalancerFrontendIpConfigurations: [
      {
        id: loadbalancer.properties.frontendIPConfigurations[0].id
      }
    ]
    ipConfigurations: [
      {
        name: 'NAT-1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName,'privateLinkSubnet')
          }
        }
      }
    ]
  }
}

