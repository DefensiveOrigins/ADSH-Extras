Write-Output "[+] GMSA Setup" 
cd c:\ADSH\GMSA
$action = New-ScheduledTaskAction “c:\ADSH\GMSA\gmsalog.bat”
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserID adshclass\gmsa_bobrep$ -LogonType Password
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Test GMSA" -Description "Runs every minute" -Principal $principal
Write-Output "[!] Donep" 
