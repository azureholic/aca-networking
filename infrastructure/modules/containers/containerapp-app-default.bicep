param region string
param environmentName string
param applicationName string 

resource acaenv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: environmentName
}


resource defaultapp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: applicationName
  location: region
  properties: {
    environmentId: acaenv.id
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
         external: true
         targetPort: 80
      }
    }
    template: {
       containers: [
         {
            name: 'simple-hello-world-container'
            image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
            resources: {
              cpu: json('0.25')
              memory: '.5Gi'
            }
         }
       ]
    }
  }
}
