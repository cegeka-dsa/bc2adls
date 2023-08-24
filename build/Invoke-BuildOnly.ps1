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

New-cdsaAzureDevOpsSection -Message "Compile AL Project: $ProjectFolder"
Start-cdsaCompileALProject -BaseAppName $BaseAppName `
    -BaseAppModifiedName $BaseAppModifiedName `
    -ContainerName $ContainerName `
    -ProjectFolder $ProjectFolder `
    -AppsToCompile $ProjectFolder `
    -OutputFolder $ProjectFolder `
    -OutputCompilerLogs `
    -Verbose

$AppPackageName = Get-cdsaAppPackageName -AppFolder $ProjectFolder
$AppPackageNameParts=$AppPackageName.Split("_")
$AppPublisher = $AppPackageNameParts[0]
$AppName = $AppPackageNameParts[1]
$AppVersion = $AppPackageNameParts[2].Replace('.app','')
Write-Verbose "AppName: $AppName, Publisher: $AppPublisher, version: $AppVersion"

$TargetAppFile = Join-Path $ProjectFolder $AppPackageName
Write-Output "##vso[task.setvariable variable=TargetAppFile]$TargetAppFile" -Verbose
Write-Output "##vso[task.setvariable variable=AppVersion]$AppVersion" -Verbose

New-cdsaAzureDevOpsSection -EndSection