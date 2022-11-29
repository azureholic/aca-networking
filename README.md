# Azure Container Apps - Networking

Bicep deployment of an Azure Container App Environment with a private link exposed with Azure Frontdoor

after deployment you need to approve the private endpoint in the Private Link Service that Azure Front Door is asking for
![Screenshot private endpoint approval](https://github.com/azureholic/aca-networking/blob/main/images/approve-fd-pe-request.png?raw=true)
You should now be able to browse to the Front Door Url and see the output of the container app even though is isolated in a private VNET.
It might take a few seconds for the private endpoint to be available.

![frontdoor URL](https://github.com/azureholic/aca-networking/blob/main/images/afd-endpoint.png?raw=true)

