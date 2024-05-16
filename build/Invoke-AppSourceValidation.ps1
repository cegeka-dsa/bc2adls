#
# Trigger Validation Build
#
[CmdletBinding()]
param(
    #ENV Variables
    [Parameter(Mandatory = $false)][string] $BuildId = $env:BUILD_BUILDID,
    [Parameter(Mandatory = $false)][string] $ERPBranchName = $ENV:ERPBranchName,
    [Parameter(Mandatory = $false)][boolean] $ForceAppSourceValidation = [System.Convert]::ToBoolean($env:FORCEAPPSOURCEVALIDATION),
    [Parameter(Mandatory = $false)][string] $BuildBranchName = $env:BUILD_SOURCEBRANCHNAME,
    [Parameter(Mandatory = $false)][string] $CurrentBuildDefinition = $env:SYSTEM_DEFINITIONID,
    # Static parameters
    [Parameter(Mandatory = $false)][string] $AppSourceBuildDefinitionID = 529
)

$Context = New-cdsaAzureDevOpsAPIContext -Organization 'cegekadsa' `
    -Project 'DynamicsEmpire' `
    -PersonalAccessToken $env:TOKEN

if (($BuildBranchName -in ("main","master")) -or $ForceAppSourceValidation) {
    New-cdsaAzureDevOpsSection -Message "Start 'AppSource Validation' build"
    Start-cdsaAzureDevOpsBuild -Context $Context `
        -BuildDefinitionId $AppSourceBuildDefinitionID `
        -SourceBranch "cosminahristofor_master_217878" `
        -QueryParameters @{ "api-version" = '5.1' } `
        -BuildParameters @{ "ERPBuildId" = $BuildId; "ERPALFullBuildDefinitionID" = $CurrentBuildDefinition } `
        -Verbose
} else {
    Write-Verbose "No appsource validation - Branchname: $BuildBranchName and ForceAppSourceValidation: $ForceAppSourceValidation"
}
New-cdsaAzureDevOpsSection -EndSection