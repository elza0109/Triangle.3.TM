Add-PSSnapin "Microsoft.SharePoint.PowerShell"
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Force

$siteUrl = 'http://whatsontri.hutch.co.id/IT'
$listName = 'Capacity Tracking Master'
$WFName = 'ContractEndWarning'
$CurrentServerTime = Get-Date -Format "MM-dd-yyyy"

$ContractEndDate = 'Contract_x0020_End'

$web = Get-SPWeb -Identity $siteUrl
$manager = $web.Site.WorkFlowManager
$list = $web.Lists[$listName]
$assoc = $list.WorkflowAssociations.GetAssociationByName($WFName,"en-US")
$data = $assoc.AssociationData
$items = $list.Items

ForEach ($item in $items)
{
    if ($item[$ContractEndDate]){
        $reminderDate1 = [datetime]$item[$ContractEndDate].AddDays(-30)
	    $reminderDate2 = [datetime]$item[$ContractEndDate].AddDays(-14)
	    $reminderDate3 = [datetime]$item[$ContractEndDate].AddDays(-7)
        if ([datetime]$CurrentServerTime -eq $reminderDate1 -or [datetime]$CurrentServerTime -eq $reminderDate2 -or [datetime]$CurrentServerTime -eq $reminderDate3){
            $wf = $manager.StartWorkFlow($item,$assoc,$data,$true)
        }
    }
}
$manager.Dispose()
$web.Dispose()