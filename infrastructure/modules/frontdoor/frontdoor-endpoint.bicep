param azureFrontDoorName string
param applicationName string

resource endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2022-05-01-preview' = {
  name : '${azureFrontDoorName}/${applicationName}'
  location : 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

output name string = endpoint.name

