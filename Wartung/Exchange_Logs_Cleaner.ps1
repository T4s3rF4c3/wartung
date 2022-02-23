## Copied and cleaned up the script from https://gallery.technet.microsoft.com/Clear-Exchange-2013-Log-71abba44
## Tested on Exchange 2016

$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -ne 'RemoteSigned') {
    Set-Executionpolicy RemoteSigned -Force
}

$exins = $env:exchangeinstallpath
$days = 7
$IISLogPath = "C:\inetpub\logs\LogFiles\"
$ExchangeLoggingPath = $exins + "Logging\"
$ETLLoggingPath = $exins + "Bin\Search\Ceres\Diagnostics\ETLTraces\"
$ETLLoggingPath2 = $exins + "Bin\Search\Ceres\Diagnostics\Logs"

Function CleanLogfiles($TargetFolder)
{
    Write-Host -ForegroundColor Yellow -BackgroundColor Black $TargetFolder

    if (Test-Path $TargetFolder) {
        $Now = Get-Date
        $LastWrite = $Now.AddDays(-$days)
        $Files = Get-ChildItem $TargetFolder  -Recurse | Where-Object { $_.Extension -in '.log', '.blg', '.etl' -and $_.LastWriteTime -le $lastwrite } | Select-Object -ExpandProperty FullName  
        
        foreach ($File in $Files)
        {
            Write-Host "Deleting file $File" -ForegroundColor "yellow";
            try {
                Remove-Item $File -ErrorAction Stop
            }
            catch {
                Write-Warning -Message $_.Exception.Message
            }
            
        }
    }
    else {
        Write-Host "The folder $TargetFolder doesn't exist! Check the folder path!" -ForegroundColor "red"
    }
}

CleanLogfiles($IISLogPath)
CleanLogfiles($ExchangeLoggingPath)
CleanLogfiles($ETLLoggingPath)
CleanLogfiles($ETLLoggingPath2)