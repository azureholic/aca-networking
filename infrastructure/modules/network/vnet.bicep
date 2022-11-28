param region string 
param vnetName string
param vnetAddressPrefix string 
param subnets array


resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: subnets
  }
}

output virtualNetwork_Name string = vnet.name
