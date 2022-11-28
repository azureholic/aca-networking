param region string
param azureFrontDoorName string
param applicationName string
param originName string
param originFqdn string
param privateLinkName string


resource privateLink 'Microsoft.Network/privateLinkServices@2022-05-01' existing = {
  name : privateLinkName
}

resource endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2022-05-01-preview' = {
  name : '${azureFrontDoorName}/${applicationName}'
  location : 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2022-05-01-preview' = {
  name : '${azureFrontDoorName}/${applicationName}'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 120
    }
    sessionAffinityState: 'Disabled'
  }
}

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

//TODO: We need a route
