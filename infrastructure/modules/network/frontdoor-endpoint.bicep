param region string
param azureFrontDoorName string
param applicationName string
param originName string
param originFqdn string
param privateLinkName string


resource privateLink 'Microsoft.Network/privateLinkServices@2022-05-01' existing = {
  name : privateLinkName
}

resource profile 'Microsoft.Cdn/profiles@2022-05-01-preview' = {
  name: azureFrontDoorName
  location: 'Global'
  sku: {
    name: 'Premium_AzureFrontDoor'
  }
  properties: {
     originResponseTimeoutSeconds: 60
     extendedProperties: {}
  }
}


resource endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2022-05-01-preview' = {
  name : '${profile.name}/${applicationName}'
  location : 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2022-05-01-preview' = {
  name : '${profile.name}/${applicationName}'
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
  name : '${originGroup.name}/${originName}'
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

resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2022-05-01-preview' = {
  name : origin.name
  properties: {
    originGroup: {
      id: originGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
}
