# Loading Microsoft.SharePoint.PowerShell
$snapin = Get-PSSnapin | Where-Object {$_.Name -eq 'Microsoft.SharePoint.Powershell'}
if ($snapin -eq $null) {
	Write-Host "Loading SharePoint Powershell Snapin"
	Add-PSSnapin "Microsoft.SharePoint.Powershell"
}

$ManagedAccount = Get-SPManagedAccount | select -First 1
if ($ManagedAccount -eq $null) { throw "No Managed Account" }

$ApplicationPool = Get-SPServiceApplicationPool "SharePoint Hosted Services" -ErrorAction SilentlyContinue
if ($ApplicationPool -eq $null)
{
	$ApplicationPool = New-SPServiceApplicationPool "SharePoint Hosted Services" -Account $ManagedAccount
	if (-not $?) { throw "Failed to create an application pool" }
}

Write-Progress "Creating Taxonomy Service Application" -Status "Please Wait..."

$MetadataseviceInstance = (Get-SPServiceInstance |?{$_.TypeName -eq "Managed Metadata Web Service"})
if (-not $?) { throw "Failed to find Metadata service instance" }

if ($MetadataseviceInstance.Status -eq "Disabled")
{
	$MetadataseviceInstance | Start-SPServiceInstance
	if (-not $?) { throw "Failed to start Metadata service instance" }
}

while (-not ($MetadataseviceInstance.Status -eq "Online"))
{
	Write-Host "Waiting for provisioning ..."; sleep 5;
}

$MetaDataServiceApp = New-SPMetadataServiceApplication -Name "Managed Metadata Service" -ApplicationPool $ApplicationPool
if (-not $?) {throw "Failed to create Metadata Service Application" }

$MetadataServiceAppProxy = New-SPMetadataServiceApplicationProxy -Name "Managed Metadata Service" -ServiceApplication $MetaDataServiceApp -DefaultProxyGroup

# This service application is the default storage location for Keywords. 
$MetadataServiceAppProxy.Properties["IsDefaultKeywordTaxonomy"] = $false 

# This service application is the default storage location for column specific term sets. 
$MetadataServiceAppProxy.Properties["IsDefaultSiteCollectionTaxonomy"] = $false 

# Consumes content types from the Content Type Gallery 
$MetadataServiceAppProxy.Properties["IsNPContentTypeSyndicationEnabled"] = $false 

# Push-down Content Type Publishing updates from the Content Type Gallery 
# to sub-sites and lists using the content type. 
$MetadataServiceAppProxy.Properties["IsContentTypePushdownEnabled"] = $false 

$MetadataServiceAppProxy.Update()