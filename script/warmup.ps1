Add-PSSnapin "Microsoft.SharePoint.PowerShell"
Set-ExecutionPolicy -ExecutionPolicy "Unrestricted" -Force
Get-SPWebApplication | ForEach-Object { Invoke-WebRequest $_.url -UseDefaultCredentials -UseBasicParsing }