$ErrorActionPreference = "Stop"
function ExtractLogFiles([string] $httpLogPath,[string]$httpLogImport)
{        
    $date = Get-Date -format "yyyy-MM-dd"
    If ((Test-Path $httpLogImport) -eq $false)
    {New-Item -ItemType directory -Path $httpLogImport | Out-Null}    
	Get-ChildItem $httpLogPath -Filter "*.log" | Where-Object -FilterScript {($_.LastWriteTime -lt  $date)} | ForEach-Object {Move-Item $_.FullName $httpLogImport}
}
function ImportLogFiles([string] $httpLogImport)
{
    [string] $logParser = "${env:ProgramFiles(x86)}" `
        + "\Log Parser 2.2\LogParser.exe"
    [string] $query = `
        [string] $query = `
        "SELECT" `
            + " LogFilename" `
            + ", RowNumber" `
            + ", TO_TIMESTAMP(date, time) AS EntryTime" `
            + ", cs-method AS Method" `
            + ", cs-uri-stem AS UriStem" `
            + ", cs-uri-query AS UriQuery" `
            + ", s-port AS Port" `
            + ", cs-username AS Username" `
            + ", c-ip AS ClientIpAddress" `
            + ", cs(User-Agent) AS UserAgent" `
            + ", cs(Cookie) AS Cookie" `
            + ", cs(Referer) AS Referrer" `
            + ", sc-status AS HttpStatus" `
            + ", sc-substatus AS HttpSubstatus" `
            + ", sc-win32-status AS Win32Status" `
            + ", sc-bytes AS BytesFromServerToClient" `
            + ", cs-bytes AS BytesFromClientToServer" `
            + ", time-taken AS TimeTaken" `
        + " INTO IISLogDetails" `
        + " FROM $httpLogImport\*.log"        
    [string] $connectionString = "Driver={SQL Server Native Client 10.0};" `
        + "Server=JKTMMSPDB;Database=WFE_Log_DB;Trusted_Connection=yes;"    
    [string[]] $parameters = @()    
    $parameters += $query
    $parameters += "-i:W3C"
    $parameters += "-o:SQL"
    $parameters += "-oConnString:$connectionString"    
    Write-Debug "Parameters: $parameters"    
    & $logParser $parameters
}
function ArchieveLogFiles([string] $httpLogArchive,[string]$httpLogImport)
{        
    $date = Get-Date -format "yyyy-MM-dd"
    If ((Test-Path $httpLogArchive) -eq $false)
    {New-Item -ItemType directory -Path $httpLogArchive | Out-Null}    
	Get-ChildItem $httpLogImport -Filter "*.log" | ForEach-Object {Move-Item $_.FullName $httpLogArchive}
}
function RemoveLogFiles([string] $httpLogPath)
{
    If ([string]::IsNullOrEmpty($httpLogPath) -eq $true)
    {
        Throw "The log path must be specified."    
    }     
    Remove-Item ($httpLogPath + "\*.log")
}   
function Main
{
    [string] $httpLogPath = "C:\inetpub\logs\LogFiles\W3SVC909509156"
    [string] $httpLogImport = $httpLogPath + "\Import"
    [string] $httpLogArchive = $httpLogPath + "\Archive"
    ExtractLogFiles $httpLogPath $httpLogImport
    ImportLogFiles $httpLogImport
    ArchieveLogFiles $httpLogArchive $httpLogImport 
}
Main