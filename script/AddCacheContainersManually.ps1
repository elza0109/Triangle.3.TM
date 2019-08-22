# Check to see if using Windows PowerShell or the SharePoint Management Shell

# If using Windows PowerShell, then the SharePoint snap-in needs to be loaded

if ((Get-PSSnapin -Name Microsoft.SharePoint.PowerShell) -eq $null)

{

Add-PSSnapin -Name Microsoft.SharePoint.PowerShell

}

# Get the GUID for the farm and store it as $farmid

$farmid = (Get-SPFarm).Id.ToString()

# Create the missing cache containers

New-Cache -CacheName "DistributedAccessCache_$farmid"

New-Cache -CacheName "DistributedActivityFeedCache_$farmid"

New-Cache -CacheName "DistributedActivityFeedLMTCache_$farmid"

New-Cache -CacheName "DistributedBouncerCache_$farmid"

New-Cache -CacheName "DistributedDefaultCache_$farmid"

New-Cache -CacheName "DistributedLogonTokenCache_$farmid"

New-Cache -CacheName "DistributedSearchCache_$farmid"

New-Cache -CacheName "DistributedSecurityTrimmingCache_$farmid"

New-Cache -CacheName "DistributedServerToAppServerAccessTokenCache_$farmid"

New-Cache -CacheName "DistributedViewStateCache_$farmid"