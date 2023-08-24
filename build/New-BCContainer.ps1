[CmdletBinding()]
param(
    $ProjectFolder,
    $DownloadFolder = (join-path $Env:Build_ArtifactStagingDirectory "BuildDatabase"),
    $ContainerName = $Env:ContainerName,
    $LicenseFile,
    [Parameter(Mandatory = $false)][string] $ResourceGroupName = "SYS-Storage",
    [Parameter(Mandatory = $false)][string] $StorageAccountName = "cegekadsatemplates",
    [Parameter(Mandatory = $false)][string] $StorageContainerName = "business-central-license"
)

$JsonPath = (join-path $DownloadFolder 'build.json')
$BakFile =  (join-path $DownloadFolder 'database.bak')

if (!(test-path $ProjectFolder -PathType Container)) {
    Write-Error "Path to project folder [$ProjectFolder] could not be found"
}
New-cdsaAzureDevOpsSection -Message "Download BC License from Az Storage"
$StorageContext = New-cdsaAzureStorageContext -ResourceGroupName $ResourceGroupName `
    -StorageAccountName $StorageAccountName

Get-AzStorageBlobContent -Container $StorageContainerName `
    -Blob "dev.bclicense" `
    -Destination $LicenseFile `
    -Context $StorageContext `
    -Force `
    -Verbose

New-cdsaAzureDevOpsSection -Message "Create BC container"
$ArtifactCountry = (Get-cdsaBCArtifactUrl -FilePath $JsonPath).Split('/')[-1]
$ArtifactVersion = (Get-cdsaBCArtifactUrl -FilePath $JsonPath).Split('/')[-2]
$BCArtifactURL = Get-BCArtifactUrl -country $ArtifactCountry -version $ArtifactVersion -select Closest

New-cdsaBCContainer -BCArtifactURL "$BCArtifactURL" `
    -ContainerName "$ContainerName" `
    -DockerImageName "" `
    -LicenseFile $LicenseFile `
    -ErrorAction Stop `
    -Verbose `
    -SharedFolders "$ProjectFolder" `
    -BackupFilePath $BakFile

New-cdsaAzureDevOpsSection -EndSection