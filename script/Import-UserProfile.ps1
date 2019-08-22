#First load the SharePoint commands
if((Get-PSSnapin | Where-Object {$_.Name -eq “Microsoft.SharePoint.PowerShell”}) -eq $null) 
{ 
Add-PSSnapIn “Microsoft.SharePoint.Powershell” 
}

#Set up the job variables
$csvfile=Read-Host “Please enter the path of the csv file”
$upAttribute = “PictureURL”,”AboutMe”,”SPS-Responsibility”,”SPS-DontSuggestList”,”HomePhone”,”SPS-TimeZone”,”SPS-PastProjects”,”SPS-Skills”,”SPS-School”,”SPS-Birthday”,”SPS-Interests”

#Connect to User Profile Manager service
$context = Get-SPServiceContext
$profileManager = New-Object Microsoft.Office.Server.UserProfiles.UserProfileManager($context)

#Create Lists from each item in CSV file
$userDetails = Import-Csv $csvfile

#Now iterate through the list to update the attribute with new value
foreach ($user in $userDetails)
{
#Check to see if user profile exists
if ($profileManager.UserExists($user.AccountName))
{
write-host “Profile for user”$user.AccountName “found”
#Get user profile and change the value
$up = $profileManager.GetUserProfile($user.AccountName)
$upAttribute | foreach-object {
if($_ -eq “SPS-Responsibility”)
{
if($user.$_.Contains(“|”))
{

#User Profile being updated for the user
$user.$_=$user.$_ -replace “\W”, ‘ ‘
$up[$_].Value = $user.$_
$up.Commit()
write-host “”$user.AccountName “-“$_ “updated “-foregroundcolor “Cyan”
}
}
else
{
$up[$_].Value = $user.$_
$up.Commit()
write-host “”$user.AccountName “-“$_ “updated “-foregroundcolor “Cyan”
}

}

}
else
{
write-host “Profile for user”$user.AccountName “cannot be found”
$profileManager.CreateUserProfile($user.AccountName)
$up = $profileManager.GetUserProfile($user.AccountName)
#$up[$upAttribute].Value = $user.PropertyVal
$upAttribute | foreach-object {
if($_ -eq “SPS-Responsibility”)
{
if($user.$_.Contains(“|”))
{

#User Profile being updated for the user
$user.$_=$user.$_ -replace “\W”, ‘ ‘
$up[$_].Value = $user.$_
$up.Commit()
write-host “”$user.AccountName “-“$_ “updated “-foregroundcolor “Cyan”
}
}
else
{
$up[$_].Value = $user.$_
$up.Commit()
write-host “”$user.AccountName “-“$_ “updated “-foregroundcolor “Cyan”
}

}
}
}

#Dispose of site object
$site.Dispose()