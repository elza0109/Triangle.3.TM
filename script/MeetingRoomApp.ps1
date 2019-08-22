Add-PSSnapin "Microsoft.SharePoint.PowerShell"
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Force

$siteUrl = 'http://triangle.hutch.co.id'
$listName = 'Meeting Room Book'
$WFName = 'ConfirmRoom'
$CurrentServerTime = Get-Date -Format "MM-dd-yyyy HH:mm:00"

$BookingDate = 'Booking_x0020_Date'
$StatusField = 'Status'

$web = Get-SPWeb -Identity $siteUrl
$manager = $web.Site.WorkFlowManager
$list = $web.Lists[$listName]
$assoc = $list.WorkflowAssociations.GetAssociationByName($WFName,"en-US")
$data = $assoc.AssociationData
$items = $list.Items

ForEach ($item in $items)
{
    if ($item[$StatusField].ToString() -eq 'BOOKED')  
    {
        $reminderDate = [datetime]$item[$BookingDate].AddMinutes(-65)        
        $autoRelease =  [datetime]$item[$BookingDate].AddMinutes(-15) 
        if ([datetime]$CurrentServerTime -ge $reminderDate -and [datetime]$CurrentServerTime -lt $autoRelease){
            $wf = $manager.StartWorkFlow($item,$assoc,$data,$true)
        }
    }
}
$manager.Dispose()
$web.Dispose()