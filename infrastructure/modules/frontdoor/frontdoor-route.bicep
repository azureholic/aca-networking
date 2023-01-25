param endPointName string
param azureFrontDoorName string
param originName string
param applicationName string

resource originGroup 'Microsoft.Cdn/profiles/originGroups@2022-05-01-preview' existing = {
  name : '${azureFrontDoorName}/${applicationName}'
}


resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2022-05-01-preview' = {
  name : '${azureFrontDoorName}/${applicationName}/${applicationName}-route'
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
