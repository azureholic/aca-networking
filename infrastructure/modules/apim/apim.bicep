param apimName string
param primaryRegion string
param additionalRegion string
param virtualNetworkName string
param additionalRegionVirtualNetworkName string
param additionalRegionPublicIpName string
param publisherEmail string
param publisherName string

resource vnet 'Microsoft.ApiManagement/service@2022-04-01-preview' = {
  name: apimName
  location: primaryRegion
  sku: {
    name: 'Premium'
    capacity: 1
  }
  properties: {
    virtualNetworkType: 'External'
    virtualNetworkConfiguration: {
      subnetResourceId: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName,'apimSubnet')
    }
    additionalLocations:[
      {
        location: additionalRegion
        sku: {
          name: 'Premium'
          capacity: 1
        }
        virtualNetworkConfiguration:{
          subnetResourceId: resourceId('Microsoft.Network/VirtualNetworks/subnets', additionalRegionVirtualNetworkName,'apimSubnet')
        }
        publicIpAddressId: resourceId('Microsoft.Network/publicIPAddresses', additionalRegionPublicIpName)
      }
    ]
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}
