[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $ResourceGroup
)
az deployment group create `
-g $ResourceGroup `
--template-file .\main.bicep `
--parameters .\params.json