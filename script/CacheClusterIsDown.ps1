$Farm=Get-SPFarm
$CacheService=$Farm.Services | Where {$_.Name -eq "AppFabricCachingService"}
$Accnt = Get-SPManagedAccount -Identity HUTCH\portal.adm
$CacheService.ProcessIdentity.CurrentIdentityType = "SpecificUser"
$CacheService.ProcessIdentity.ManagedAccount = $Accnt
$CacheService.ProcessIdentity.Update()