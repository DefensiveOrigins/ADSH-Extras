Write-Output "[*] Download Bootstrap Script" 
New-Item -ItemType Directory -Path "C:\ADSH\Bootstrap" -Force > $null
cd C:\ADSH\Bootstrap
Invoke-WebRequest -URI https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/Bootstrap.ps1 -OutFile Bootstrap.ps1
ls C:\ADSH\Bootstrap | Select-Object Name, Length


Write-Output "[*] Setup Boot Scheduled Task"
$script = 'C:\ADSH\Bootstrap\Bootstrap.ps1'
$action   = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$script`""
$trigger  = New-ScheduledTaskTrigger -AtStartup
$principal= New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
Register-ScheduledTask -TaskName 'ADSH Bootstrap' -Action $action -Trigger $trigger -Principal $principal

Write-Output "[*] Restart Computer"
restart-Computer