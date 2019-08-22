if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {Add-PSSnapin Microsoft.SharePoint.PowerShell;}

$path = "C:\data_sharepoint\exclude.txt"
$sourceWebURL = "http://whatsontri.hutch.co.id/"
$sourceListName = "popupTracker"

$spSourceWeb = Get-SPWeb $sourceWebURL
$spSourceList = $spSourceWeb.Lists[$sourceListName]
$spSourceItems = $spSourceList.GetItems()
if (Test-Path $path ){Clear-Content $path}
$spSourceItems | ForEach-Object {$_['Title'].Replace(".txt","") >> $path}