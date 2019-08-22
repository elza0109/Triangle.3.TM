#Setup Variables - Assume 2 Servers (App & Web)
#Assume 3 Accounts (Content Access, Admin, Query)
#### Note - You should setup the Index Location prior to running these commands and ensure it is an empty folder
#### Note - If you setup diag logging prior to running script, ensure you give dbo permissions to the account you run this under 

write-host 0. Setting up some initial variables.
$AppSvr = "jktmmspapp"
$WebSvr = "jktmmspwfe"
$CAAcct = "hutch\portal.adm"
$password = "P@ssw0rd713"
$CAAcctPW = ConvertTo-SecureString -String $password -AsPlainText -Force
$AdminAcct = "hutch\portal.adm"
$QueryAcct = "hutch\portal.adm"
$SSAName = "EnterpriseSearch"
$SSIAppSvr = get-SPServiceInstance -server $AppSvr | ?{$_.TypeName -eq "SharePoint Server Search"}
$SSIWebSvr = get-SPServiceInstance -server $WebSvr | ?{$_.TypeName -eq "SharePoint Server Search"}
$IndexLocation = "C:\SPSearchIndex"
$err = $null

#Start Services for SSI 
write-host 1. Start Services search services for Each Server
Start-SPEnterpriseSearchServiceInstance -Identity $SSIAppSvr
Start-SPEnterpriseSearchServiceInstance -Identity $SSIWebSvr


#Create Application Pools 
write-host 2. Create a Application Pools
$AdminAppPool = new-SPServiceApplicationPool -name $SSAName"-AdminAppPool" -account $AdminAcct 
$QueryAppPool = new-SPServiceApplicationPool -name $SSAName"-QueryAppPool" -account $QueryAcct

#Create Search Service Application 
write-host 3. Create the SearchApplication and set it to a variable
$SearchApp = New-SPEnterpriseSearchServiceApplication -Name $SSAName -applicationpool $AdminAppPool -databasename $SSAName"_AdminDB"

#Create Search Service Application Proxy 
write-host 4. Create search service application proxy
$SSAProxy = new-spenterprisesearchserviceapplicationproxy -name $SSAName"ApplicationProxy" -SearchApplication $SearchApp

#Clone Search Topology (this is empty by default) 
write-host 5. Clone Search Topology
$SearchTopology = $SearchApp.ActiveTopology.Clone()

#Provision Search Administration Component 
write-host 6. Provision Search Admin Component.
New-SPEnterpriseSearchAdminComponent -SearchServiceInstance $SSIAppSvr -SearchTopology $SearchTopology

#Provision New Search Content Processing Component 
write-host 7. Create New Search Content Processing Component
New-SPEnterpriseSearchContentProcessingComponent -SearchServiceInstance $SSIAppSvr -SearchTopology $SearchTopology

#Provision New Search Analytics Processing Component 
write-host 8. Create New Search Analytics Processing Component
New-SPEnterpriseSearchAnalyticsProcessingComponent -SearchServiceInstance $SSIAppSvr -SearchTopology $SearchTopology

#Provision New Search Crawl Component 
write-host 9. Create New Search Crawl Component
New-SPEnterpriseSearchCrawlComponent -SearchServiceInstance $SSIAppSvr -SearchTopology $SearchTopology

#Provision New Search Index Component 
write-host 10. Create New Search Index Component
New-SPEnterpriseSearchIndexComponent -SearchServiceInstance $SSIWebSvr -SearchTopology $SearchTopology -RootDirectory $IndexLocation

#Provison New Query Processing Component 
write-host 11. Create New Query Processing Component
New-SPEnterpriseSearchQueryProcessingComponent -SearchServiceInstance $SSIWebSvr -SearchTopology $SearchTopology

#Activate Topology Changes 
write-host 12. Activate Topology
$SearchTopology.Activate()

#Setup default Content Access Account 
write-host 13. Set the default content access account
Set-SPEnterpriseSearchServiceApplication –Identity $SearchApp -ApplicationPool $QueryAppPool -DefaultContentAccessAccountName $CAAcct -DefaultContentAccessAccountPassword $CAAcctPW

Write-host "Your search application $SSAName is now ready"