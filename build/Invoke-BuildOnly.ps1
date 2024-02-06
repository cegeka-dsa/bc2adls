#
# Buildsteps to only Compile (CI)
#
param(
    [Parameter(Mandatory = $false)][string] $BaseAppName = "BaseApp",  
    [Parameter(Mandatory = $false)][string] $BaseAppModifiedName = "BaseApplicationModified",
    [Parameter(Mandatory = $false)][string] $BuildId = $env:BUILD_BUILDID,
    [Parameter(Mandatory = $false)][string] $ContainerName = $env:CONTAINERNAME,
    [Parameter(Mandatory = $false)][string] $ProjectFolder = $env:ProjectFolder
)
#Import-Module "C:\Projects\Git\DevOps.PSModules\Modules\cdsa.build.al\cdsa.build.al.psm1" -Force
#$ProjectFolder = (Get-Location).Path + "\BusinessCentral"
New-cdsaAzureDevOpsSection -Message "Get the list of Apps that need to compile"
$SortedApps = Get-cdsaAppsListToCompile -ProjectFolder $ProjectFolder -Verbose

New-cdsaAzureDevOpsSection -Message "Compile AL Project: $ProjectFolder"
$BuildCredential = Get-cdsaBuildServerCredential
foreach($AppFolder in $SortedApps) {
    $AppFilename = Compile-AppInNavContainer `
        -credential $BuildCredential `
        -containerName $ContainerName `
        -appProjectFolder $AppFolder `
        -appSymbolsFolder $ProjectFolder `
        -appOutputFolder $ProjectFolder

    # Use primary filename
    if (!$TargetAppFile) {
        $TargetAppFile = $AppFilename
    }
}
<#Start-cdsaCompileALProject -BaseAppName $BaseAppName `
    -BaseAppModifiedName $BaseAppModifiedName `
    -ContainerName $ContainerName `
    -ProjectFolder $ProjectFolder `
    -AppsToCompile $SortedApps `
    -OutputFolder $ProjectFolder `
    -OutputCompilerLogs `
    -Verbose
#>

$AppPackageName = Split-Path $TargetAppFile -Leaf
$AppPackageNameParts=$AppPackageName.Split("_")
$AppPublisher = $AppPackageNameParts[0]
$AppName = $AppPackageNameParts[1]
$AppVersion = $AppPackageNameParts[2].Replace('.app','')
Write-Verbose "AppName: $AppName, Publisher: $AppPublisher, version: $AppVersion"

Write-Output "##vso[task.setvariable variable=TargetAppFile]$TargetAppFile" -Verbose
Write-Output "##vso[task.setvariable variable=AppVersion]$AppVersion" -Verbose

New-cdsaAzureDevOpsSection -EndSection