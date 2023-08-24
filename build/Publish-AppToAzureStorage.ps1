param(
    #Environment parameters
    [Parameter(Mandatory = $false)][string] $SourceFile,
    [Parameter(Mandatory = $false)][string] $StorageAccountName,
    [Parameter(Mandatory = $false)][string] $StorageContainer
)

New-cdsaAzureDevOpsSection -Message "Publish file to Azure BLOB storage: $StorageAccountName in container $StorageContainer"
$StorageContext = New-cdsaAzureStorageContext -StorageAccountName $StorageAccountName
Set-AzStorageBlobContent -File $SourceFile -Container $StorageContainer -Context $StorageContext -Force