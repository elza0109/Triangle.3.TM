Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
  
# Variables
$WebAppURL = "http://triangle.three.co.id/"
$StartTime = "01/01/2016 01:00:00 AM"  # mm/dd/yyyy hh:mm:ss
$EndTime = "05/01/2016 01:30:00 AM"
$OutPutFile="C:\DATA\FailedJobHistoryRpt.csv"
 
#Get all timer jobs associated with a web application
$WebApp = Get-SPWebApplication $WebAppURL
 
#Get all Failed Timer jobs in between given Time
$Results = $WebApp.JobHistoryEntries | Where {($_.StartTime -ge $StartTime) -and ($_.EndTime -le $EndTime) -and ($_.Status -ne 'Succeeded')}
 
#Export to CSV
$Results | Export-Csv $OutPutFile –NoType
 
write-host "Failed Timer jobs history Exported to CSV!" -F Green