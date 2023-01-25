param region string = resourceGroup().location
param environmentName string
param applicationName string
param vnetAddressPrefix string 
param subnets array

module network 'modules/network/vnet.bicep' = {
  name: 'vnet-deploy'
  params : {
    vnetName: 'vnet-${environmentName}'
    vnetAddressPrefix: vnetAddressPrefix
    subnets: subnets
    region : region
  }
}

module loganalytics 'modules/monitoring/loganalytics.bicep' = {
  name: 'log-analytics-deploy'
  params :{
    region: region
    workspaceName: 'ws-${environmentName}' 
  }
}

module acaenvironment 'modules/containers/containerapp-environment.bicep' = {
  name: '${environmentName}-deploy'
  params :{
    region: region
    environmentName: environmentName
    virtualNetworkName: network.outputs.virtualNetwork_Name
    logAnalyticsName: 'ws-${environmentName}'
  }
}

module privatelink 'modules/network/aca-privatelink.bicep' = {
  name: 'privatelink-deploy'
  params: {
    managedResourceGroupName: acaenvironment.outputs.managedResourceGroupName
    privateLinkName: 'privatelink-${environmentName}'
    region: region
    virtualNetworkName: 'vnet-${environmentName}'
  }
}

module defaultApp 'modules/containers/containerapp-app-default.bicep' = {
  dependsOn: [
    acaenvironment
  ]
  name : 'default-app-deploy'
  params: {
    applicationName: applicationName
    environmentName: environmentName
    region: region
  }
}

