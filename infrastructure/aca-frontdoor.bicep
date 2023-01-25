param region string = resourceGroup().location
param environmentName string
param applicationName string
param azureFrontDoorName string

resource acaenv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: environmentName
}

module profile 'modules/frontdoor/frontdoor-profile.bicep' = {
  name: 'frontdoor-profile-deploy'
  params:{
    azureFrontDoorName: azureFrontDoorName
  }
}

module endpoint 'modules/frontdoor/frontdoor-endpoint.bicep' = {
  dependsOn: [ profile ]
  name: 'frontdoor-endpoint-deploy'
  params: {
    azureFrontDoorName: azureFrontDoorName
    applicationName:applicationName
  }
}

module origingroup 'modules/frontdoor/frontdoor-origingroup.bicep' = {
  dependsOn: [ profile ]
  name: 'frontdoor-origingroup-deploy'
  params: {
    azureFrontDoorName: azureFrontDoorName
    applicationName: applicationName
  }
}

module origin 'modules/frontdoor/frontdoor-origin.bicep' = {
  dependsOn: [ origingroup ]
  name: 'frontdoor-origin-deploy'
  params: {
    azureFrontDoorName: azureFrontDoorName
    endPointName: endpoint.outputs.name
    originName: applicationName
    originFqdn: '${applicationName}.${acaenv.properties.defaultDomain}'
    region: region
    privateLinkName:'privatelink-${environmentName}'
  }
}

module route 'modules/frontdoor/frontdoor-route.bicep' = {
  name: 'frontdoor-route-deploy'
  params:{
    applicationName: applicationName
    azureFrontDoorName: azureFrontDoorName
    endPointName: endpoint.outputs.name
    originName: origin.outputs.name
  }
}
