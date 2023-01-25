# Azure Container Apps - Networking

Bicep deployment of an Azure Container App Environment with a private link exposed with Azure Frontdoor

The repo has been refactored to support several scenarios.

### steps
Login with the AZ CLI to your subscription before running any of the powershell scripts. You can also use AZ directly to deploy the bicep files.


You can edit the parameter files to reflect your own environment. 


Provision the Default Azure Container App and an Environment in a virtual network and create the Private Link Service. 

```powershell
.\deploy-aca-internal.ps1 -resourcegroup <ResourceGroupname>
```

Provision Azure Front Door and expose the container app
```powershell
.\deploy-aca-frontdoor.ps1 -resourcegroup <ResourceGroupname>
```

After this deployment you need to approve the private endpoint in the Private Link Service that Azure Front Door is asking for
![Screenshot private endpoint approval](https://github.com/azureholic/aca-networking/blob/main/images/approve-fd-pe-request.png?raw=true)
You should now be able to browse to the Front Door Url and see the output of the container app even though is isolated in a private VNET.
It might take a few seconds for the private endpoint to be available.

![frontdoor URL](https://github.com/azureholic/aca-networking/blob/main/images/afd-endpoint.png?raw=true)

