#
# Buildsteps to compile / publish
#
param(
    [Parameter(Mandatory = $false)][string] $BaseAppName = "BaseApp",
    [Parameter(Mandatory = $false)][string] $BaseAppModifiedName = "BaseApplicationModified",
    [Parameter(Mandatory = $false)][string] $BuildId = $env:BUILD_BUILDID,
    [Parameter(Mandatory = $false)][string] $ContainerName = $env:CONTAINERNAME,
    [Parameter(Mandatory = $false)][string] $ProjectFolder = $env:ProjectFolder,
    [Parameter(Mandatory = $false)][string] $Target
)

New-cdsaAzureDevOpsSection -Message "Set version numbers"
$ApplicationVersion = Set-cdsaApplicationVersion -ContainerName $ContainerName `
    -ProjectFolder $ProjectFolder `
    -BuildId $BuildId `
    -ErrorAction Stop `
    -TakeMinorVersionFromAppJson `
    -Verbose
Write-Output "##vso[task.setvariable variable=ApplicationVersion]$ApplicationVersion"

New-cdsaAzureDevOpsSection -Message "Get list of Apps to compile"
$SortedApps = Get-cdsaAppsListToCompile -ProjectFolder $ProjectFolder `
    -Verbose

New-cdsaAzureDevOpsSection -Message "Compile AL Project(s)"
Start-cdsaCompileALProject -BaseAppName $BaseAppName `
    -BaseAppModifiedName $BaseAppModifiedName `
    -ContainerName $ContainerName `
    -ProjectFolder $ProjectFolder `
    -AppsToCompile $SortedApps `
    -OutputCompilerLogs `
    -Verbose

New-cdsaAzureDevOpsSection -Message "Publish App(s) into container"
$Tenant = "default"
Start-cdsaPublishAppsInContainer -ProjectFolder $ProjectFolder `
    -AppsToPublish $SortedApps `
    -ContainerName $ContainerName `
    -Tenant $Tenant `
    -ErrorAction Stop `
    -Verbose

New-cdsaAzureDevOpsSection -Message "Creating runtime packages"
# Create output folder
$AppFolder = (join-path (Get-cdsaContainerHelperFolder) "extensions\$ContainerName\Apps")
Write-Output "##vso[task.setvariable variable=AppRuntimeFolder]$AppFolder"

if (!(Test-path $AppFolder )) {
    New-Item -Path $AppFolder -ItemType Directory | Out-Null
}

$AppFiles = Get-ChildItem -Path $SortedApps -Filter "app.json"
foreach ($AppJsonPath in $AppFiles ) {
    $AppJson = Get-Content -Path $AppJsonPath.Fullname | ConvertFrom-Json
    $TargetAppFile = (join-path "$AppFolder" "$($AppJson.publisher)_$($AppJson.name).app")
    if ($Target -eq "OnPrem") {
        Get-NavContainerAppRuntimePackage -containerName $ContainerName -appName $AppJson.name -Tenant $Tenant -Publisher $AppJson.publisher -appVersion $AppJson.version -appFile $TargetAppFile
    }
    else {
        $BuildAppFile = (Get-ChildItem -Path $AppJsonPath.DirectoryName -Name "$($AppJson.publisher)_$($AppJson.name)_$($AppJson.version).app" -Recurse)
        Write-Verbose "Copy sourceApp $BuildAppFile in $($AppJsonPath.DirectoryName) to $TargetAppFile"
        Copy-Item -path (join-path $AppJsonPath.DirectoryName $BuildAppFile) -Destination $TargetAppFile
    }
}

New-cdsaAzureDevOpsSection -EndSection