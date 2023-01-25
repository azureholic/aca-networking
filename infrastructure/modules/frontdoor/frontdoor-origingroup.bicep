param azureFrontDoorName string
param applicationName string

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

output name string = originGroup.name
