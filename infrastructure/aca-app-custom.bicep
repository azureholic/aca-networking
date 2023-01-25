param region string = resourceGroup().location
param environmentName string
param applicationName string 
param containerImage string
param targetPort int
param cpu string
param mem string
module defaultApp 'modules/containers/containerapp-app.bicep' = {
  
  name : 'customer-app-deploy'
  params: {
    applicationName: applicationName
    environmentName: environmentName
    region: region
    containerImage: containerImage
    cpu: cpu
    mem: mem
    containerName: applicationName
    targetPort: targetPort
  }
}
