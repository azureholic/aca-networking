param region string 
param endPointName string
param frontDoorName string
param originName string
param originFqdn string
param privateLinkName string = ''

resource privateLink 'Microsoft.Network/privateLinkServices@2022-05-01' existing = if (!empty(privateLinkName)) {
  name : privateLinkName
}

resource origin_with_private_link 'Microsoft.Cdn/profiles/originGroups/origins@2022-05-01-preview' = if (!empty(privateLinkName)) {
  name : '${frontDoorName}/${endPointName}/${originName}'
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

resource origin_no_private_link 'Microsoft.Cdn/profiles/originGroups/origins@2022-05-01-preview' = if (empty(privateLinkName)) {
  name : '${frontDoorName}/${endPointName}/${originName}'
  properties: {
    hostName: originFqdn
    httpPort: 80
    httpsPort: 443
    originHostHeader: originFqdn
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}
