param region string

resource apim_nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 'nsg-apim-${region}'
  location: region
  properties: {
    securityRules: [
      {
        name: 'Allow-FrontDoor'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'AzureFrontDoor.Backend'
          destinationAddressPrefix: 'VirtualNetwork'
          description: 'Allow FrontDoor to access APIM'
        }
      }
      {
        name: 'Allow-APIM-Management'
        properties: {
          priority: 110
          access: 'Allow'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '3443'
          sourceAddressPrefix: 'ApiManagement'
          destinationAddressPrefix: 'VirtualNetwork'
          description: 'Allow APIM Management'
        }
      }
      {
        name: 'Allow-APIM-Loadbalancer'
        properties: {
          priority: 120
          access: 'Allow'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '6390'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: 'VirtualNetwork'
          description: 'Allow APIM Loadbalancer'
        }
      }
    ]
  }
}
