[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)][string] $RepositoryName = "ERP AL",  
    [Parameter(Mandatory = $false)][string] $SourceBranch = "master",
    [Parameter(Mandatory = $false)][string] $ScopePath = "/devops/build-params.json",
    [Parameter(Mandatory = $false)][string] $DestinationPath = (join-path $ENV:BUILD_REPOSITORY_LOCALPATH "build-params.json")
)

  New-cdsaAzureDevOpsSection -Message "Download build-params.json from repo: $RepositoryName and branch $SourceBranch to $DestinationPath"
  $Context = New-cdsaAzureDevOpsAPIContext -Organization "cegekadsa" `
    -Project "DynamicsEmpire" `
    -PersonalAccessToken $ENV:TOKEN

  $MainUrl = "https://dev.azure.com/{0}/{1}/_apis" -f $Context.Organization, $Context.Project
  $ItemUrl = "$MainUrl/git/repositories/$RepositoryName/items?path=$scopePath&versionType=Branch&version=$SourceBranch"
  Copy-cdsaAzureDevOpsBaseAppModifiedObject -Context $Context -DownloadUrl $ItemUrl -DestinationPath $DestinationPath -Verbose

  if (Test-Path $DestinationPath) {
    $BuildParams = (Get-Content $DestinationPath|ConvertFrom-Json)
  }
  write-verbose "StorageAccount: $($BuildParams.StorageAccount) - StorageContainer: $($BuildParams.StorageContainerExternalBCApps)"
  Write-Output "##vso[task.setvariable variable=StorageAccount]$($BuildParams.StorageAccount)" -Verbose
  Write-Output "##vso[task.setvariable variable=StorageContainer]$($BuildParams.StorageContainerExternalBCApps)" -Verbose
New-cdsaAzureDevOpsSection -EndSection