Add-PsSnapin Microsoft.SharePoint.Powershellfunction BackupSiteCollections
 
{
 
#Change below variables
 
$Location = "C:\DATA\BackUp\SiteCollection"
 
#You don’t have to change below variables
 
$Backupname = "SiteCollection80Backup_"
 
$date = get-date
 
$today = $date.ToString("ddMMyyyy")
 
$fileLocation = "$Location$Backupname$today"
 
[IO.Directory]::CreateDirectory("$filelocation")
 
$sitecollections = Get-SPSite -Identity efefd21a-cdf1-40e8-9ffd-557c714d4977
 
foreach($sitecollection in $sitecollections)
 
{
 
$tempname = $($sitecollection.url)
 
$tempname = $tempname.replace(":","_")
 
$name = $tempname.replace("/","")
 
Backup-SPSite $sitecollection -path "$($fileLocation)\$($name).bak" -force
 
} }
BackupSiteCollections