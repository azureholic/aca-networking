[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ResourceGroup
)
az deployment group create `
-g $ResourceGroup `
--template-file .\aca-frontdoor.bicep `
--parameters .\aca-frontdoor.params.json