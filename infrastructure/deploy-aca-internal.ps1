[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ResourceGroup
)
az deployment group create `
-g $ResourceGroup `
--template-file .\aca-internal.bicep `
--parameters .\aca-internal.params.json