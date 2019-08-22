Add-PSSnapin Microsoft.SharePoint.Powershell -ea SilentlyContinue
$web = get-spweb "http://whatsontri.hutch.co.id/"
$list = $web.lists["History Meeting Room Book"]
$query = New-Object Microsoft.SharePoint.SPQuery
$query.ViewAttributes = "Scope='Recursive'"
$query.RowLimit = 1000
$query.ViewFields = "<FieldRef Name='ID'/>"
$query.ViewFieldsOnly = $true
do
{
   $listItems = $list.GetItems($query)
   $query.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
   foreach($item in $listItems)
   {cls
     Write-Host "Deleting Item - $($item.Id)"
     $list.GetItemById($item.Id).delete()
   }
}
while ($query.ListItemCollectionPosition -ne $null)