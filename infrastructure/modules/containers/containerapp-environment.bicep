param region string = resourceGroup().location
param environmentName string
param virtualNetworkName string
param logAnalyticsName string


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsName
}

//create azure container app environment
resource acaenv 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: environmentName
  location: region
  properties: {
    zoneRedundant: true
    vnetConfiguration: {
      internal: true
      infrastructureSubnetId: resourceId('Microsoft.Network/VirtualNetworks/subnets', virtualNetworkName,'k8sSubnet')
    }
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: listKeys(logAnalytics.id, logAnalytics.apiVersion).primarySharedKey
      }
    }
  }
}

var appName = split(acaenv.properties.defaultDomain, '.')[0]
output managedResourceGroupName string = 'MC_${appName}-rg_${appName}_${region}'


