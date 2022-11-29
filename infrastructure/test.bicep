param region string = resourceGroup().location
param azureFrontDoorName string = 'rbrtestfd'
param applicationName string = 'rbrtestapp'
param originName string = 'rbrtestapp'
param originFqdn string = 'rbrtestapp.ashywater-08141d29.westeurope.azurecontainerapps.io'

resource privateLink 'Microsoft.Network/privateLinkServices@2022-05-01' existing = {
  name : 'caenv'
}

output id string = privateLink.id

resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2022-05-01-preview' = {
  name : '${azureFrontDoorName}/${applicationName}/${originName}'
  properties: {
    hostName: originFqdn
    httpPort: 80
    httpsPort: 443
    originHostHeader: originFqdn
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    sharedPrivateLinkResource: {
      privateLink: {
        id : privateLink.id
      }
      
      privateLinkLocation: region
      requestMessage: 'Azure Front Door request for Private Endpoint'
    }
    enforceCertificateNameCheck: true
  }
}
