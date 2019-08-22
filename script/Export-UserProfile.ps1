if ( (Get-PSSnapin -Name Microsoft.Sharepoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )
{
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
}
function DumpProfiles([System.String] $siteUrl)
{
try
{

$serviceContext = Get-SPServiceContext -Site $siteUrl
$profileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($serviceContext);
$profiles = $profileManager.GetEnumerator()
Write-Host “Exporting profiles” 
$fields = @(
“FirstName”,
“LastName”,
“PreferredName”,
“Designation”,
“AccountName”,
“WorkPhone”,
“HomePhone”,
“Extension”,
“WorkEmail”,
“CellPhone”,
“Fax”,
“Office”,
“Department”,
“Title”,
“Salutation”,
“Manager”,
“AboutMe”,
“PostalAddress”,
“AddressLine1”,
“AddressLine2”,
“PostCode”,
“Locality”,
“State”,
“Country”,
“CurrentRecord”,
“Agency”,
“PersonalSpace”,
“PictureURL”,
“UserName”,
“AGS”,
“SPS-SipAddress”,
“SPS-ClaimProviderID”,
“SPS-ClaimProviderType”,
“SPS-LastColleagueAdded”,
“SPS-SavedAccountName”,
“SPS-O15FirstRunExperience”,
“SPS-DistinguishedName”,
“SPS-SourceObjectDN”,
“SPS-LastKeywordAdded”,
“SPS-Responsibility”,
“Assistant”,
“SPS-StatusNotes”,
“SPS-PrivacyPeople”,
“SPS-DontSuggestList”,
“SPS-TimeZone”,
“SPS-PastProjects”,
“SPS-Skills”,
“SPS-School”,
“SPS-Birthday”,
“SPS-Interests”,
“UserProfile_GUID”,
“SID”
)

$collection = @()

foreach ($profile in $profiles) {
$user = “” | select $fields
foreach ($field in $fields) {
if($profile[$field].Property.IsMultivalued) {
$user.$field = $profile[$field] -join “|”
}
else {
$user.$field = $profile[$field].Value
}
}
$collection += $user
}

$collection | Export-Csv UserProfileDump.csv -NoTypeInformation
}
catch
{
“Caught in a catch”
$err=$Error[0]
$err
$err |Format-List *
“General Exceptions caught: ” >> “[Environment]::CurrentDirectory\errorlog.txt”
$_.Exception.Message >> “[Environment]::CurrentDirectory\errorlog.txt”
}

}

$siteUrl=Read-Host “Please enter the FWONet url”
DumpProfiles($siteUrl)
Write-Host All content will be written to [Environment]::CurrentDirectory