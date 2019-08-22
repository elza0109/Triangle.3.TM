Get-WmiObject -Class Win32_PerfFormattedData_W3SVC_WebService -ComputerName JKTMMSPWFE,JKTMMSPAPP | Where {$_.Name -eq "_Total"} | % `
{
    $ServerName = $_.__SERVER;
    $Connections = $_.CurrentConnections
    $String +="$ServerName : $Connections`n"
    Write-Host "$ServerName : $Connections" 
}