Add-PSSnapin "Microsoft.SharePoint.PowerShell"
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Force

$path="C:\DATA\BackUp\SiteCollection\SiteCollection80" + ".bak"
Backup-SPSite -Identity efefd21a-cdf1-40e8-9ffd-557c714d4977 -Path $path -NoSiteLock -Force