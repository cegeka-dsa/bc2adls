#
# Buildsteps to only Compile (CI)
#
param(
    [Parameter(Mandatory = $false)][string] $BaseAppName = "BaseApp",  
    [Parameter(Mandatory = $false)][string] $BaseAppModifiedName = "BaseApplicationModified",
    [Parameter(Mandatory = $false)][string] $BuildId = $env:BUILD_BUILDID,
    [Parameter(Mandatory = $false)][string] $ContainerName = $env:CONTAINERNAME,
    [Parameter(Mandatory = $false)][string] $ProjectFolder = $env:ProjectFolder,
    [Parameter(Mandatory = $false)][boolean] $SignApp = [System.Convert]::ToBoolean($env:SIGNAPP),
    [Parameter(Mandatory = $false)][string] $AppSourceConfigPath = $ENV:APPSOURCECONFIGPATH,
    [Parameter(Mandatory = $false)][string] $AppSourceConfigOutputPath = $ENV:APPSOURCECONFIGOUTPUTPATH,
    # Static parameters
    [Parameter(Mandatory = $false)][string] $SecretKeyVaultName = "DE-KeyVault-OAuth",
    [Parameter(Mandatory = $false)][string] $CertificateKeyVaultSecretName = "CodeSign",
    [Parameter(Mandatory = $false)][string] $CertificateName = "CodeSignCertificate",
    [Parameter(Mandatory = $false)][string] $CertificateKeyVaultName = "CodeSignERP",
    [Parameter(Mandatory = $false)][string] $TenantId = "402b1b00-ddb0-4bc7-b61c-50afb351bb17",
    [Parameter(Mandatory = $false)][string] $ClientId = "0ff06a49-7d08-4578-99f6-64b5089293ad",
    [Parameter(Mandatory = $false)][string] $Description = "Signed with Zig ERP Builds for AppSource deployment.",
    [Parameter(Mandatory = $false)][string] $DescriptionUrl = "https:\\www.zig.nl"
)
New-cdsaAzureDevOpsSection -Message "Set version numbers"
$ApplicationVersion = Set-cdsaApplicationVersion -ContainerName $ContainerName `
    -ProjectFolder $ProjectFolder `
    -BuildId $BuildId `
    -ErrorAction Stop `
    -TakeMinorVersionFromAppJson `
    -Verbose

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
if ($SignApp) {
    New-cdsaAzureDevOpsSection -Message "Signing App $TargetAppFile"
    $CertificateKeyVaultSecret = (Get-AzKeyVaultSecret -VaultName $SecretKeyVaultName -Name $CertificateKeyVaultSecretName).SecretValue
    Invoke-cdsaALAppSignInContainer -containerName $ContainerName -KeyVaultName $CertificateKeyVaultName `
     -CertificateName $CertificateName `
     -ClientId $ClientId `
     -ClientSecret $CertificateKeyVaultSecret `
     -TenantId $TenantId `
     -FilesToSign $TargetAppFile `
     -Description $Description `
     -DescriptionUrl $DescriptionUrl -Verbose
}

New-cdsaAzureDevOpsSection -Message "Make sure the main app doesnt exist in the container"
$Apps = Get-NavContainerAppInfo -containerName $ContainerName 
foreach($App in $Apps|Where-Object {$_.appId -eq "f50ed17c-be40-4d00-ad13-2e5132038664"}) {
    UnPublish-NavContainerApp -containerName $ContainerName -name $App.Name -publisher $App.publisher -version $App.version -unInstall 
}

New-cdsaAzureDevOpsSection -Message "Publish the main app $TargetAppFile"
Publish-NavContainerApp -Container $ContainerName `
    -appFile $TargetAppFile `
    -skipVerification `
    -sync

New-cdsaAzureDevOpsSection -Message "Create AppSource config file"
if ($AppSourceConfigPath) {
    New-cdsaAppSourceConfig -Container $ContainerName `
        -AppSourceConfigPath $AppSourceConfigPath `
        -OutputPath $AppSourceConfigOutputPath `
        -Verbose
}

$AppPackageName = Split-Path $TargetAppFile -Leaf
$AppPackageNameParts=$AppPackageName.Split("_")
$AppPublisher = $AppPackageNameParts[0]
$AppName = $AppPackageNameParts[1]
$AppVersion = $AppPackageNameParts[2].Replace('.app','')
Write-Verbose "AppName: $AppName, Publisher: $AppPublisher, version: $AppVersion"

Write-Output "##vso[task.setvariable variable=TargetAppFile]$TargetAppFile" -Verbose
Write-Output "##vso[task.setvariable variable=AppVersion]$AppVersion" -Verbose

New-cdsaAzureDevOpsSection -EndSection