Add-PSSnapin Microsoft.SharePoint.PowerShell
 
[System.reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$web = Get-SPWeb "http://triangle.three.co.id/"
$list = $web.Lists["Meeting Room Book"]
$caml = '<Where><And><Geq><FieldRef Name="Booking_x0020_Date" /><Value IncludeTimeValue="TRUE" Type="DateTime">2019-06-01T00:00:00Z</Value></Geq><Leq><FieldRef Name="Booking_x0020_Date" /><Value IncludeTimeValue="TRUE" Type="DateTime">2019-06-30T23:59:59Z</Value></Leq></And></Where>'
$query=new-object Microsoft.SharePoint.SPQuery
$query.Query=$caml
$col=$list.GetItems($query)
Write-Host $col.Count
$col | % {$list.GetItemById($_.Id).Delete()}
$web.Dispose()