Get-GPO -all | Format-Table -property DisplayName,GpoStatus,id -AutoSize



cd c:\ADSH
New-Item -ItemType Directory -Path "C:\ADSH\GPOs" -Force > $null
cd C:\ADSH\GPOs
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -URI https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/GPOs/GPOs.zip -OutFile C:\ADSH\GPOs\ADSH-GPOs.zip

$ProgressPreference = 'Continue'
Expand-Archive ADSH-GPOs.zip
Remove-Item ADSH-GPOs.zip
ls C:\ADSH\GPOs\ADSH-GPOs\GPOs



Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-Security" -CreateIfNeeded -TargetName "ADSH-Security" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-main2" -CreateIfNeeded -TargetName "ADSH-main2" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-main" -CreateIfNeeded -TargetName "ADSH-main" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-ApplockWrite" -CreateIfNeeded -TargetName "ADSH-ApplockWrite"
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-EnableFirewall" -CreateIfNeeded -TargetName "ADSH-EnableFirewall" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-login" -CreateIfNeeded -TargetName "ADSH-login" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-LA" -CreateIfNeeded -TargetName "ADSH-LA" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "ADSH-STM" -CreateIfNeeded -TargetName "ADSH-STM" 
Import-GPO -Path C:\ADSH\GPOs\ADSH-GPOs\GPOs -BackupGpoName "GPP-Passwords" -CreateIfNeeded -TargetName "GPP-Passwords" 


Get-GPO -all | Format-Table -property DisplayName,GpoStatus,id -AutoSize


cd c:\ADSH
New-GPLink -Name "ADSH-login" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-main" -Target "dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-main2" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-ApplockWrite" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-EnableFirewall" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-LA" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-STM" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "ADSH-Security" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes
New-GPLink -Name "GPP-Passwords" -Target "ou=ADSHMedical,dc=adshclass,dc=com" -LinkEnabled Yes




cd c:\ADSH\
New-Item -ItemType Directory -Path "C:\ADSH\GPO-Reports" -Force > $null
cd C:\ADSH\GPO-Reports

Get-GPOReport -Name "ADSH-login" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-login.html"
Get-GPOReport -Name "ADSH-main" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-main.html"
Get-GPOReport -Name "ADSH-main2" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-main2.html"
Get-GPOReport -Name "ADSH-ApplockWrite" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-ApplockWrite.html"
Get-GPOReport -Name "ADSH-EnableFirewall" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-EnableFirewall.html"
Get-GPOReport -Name "ADSH-LA" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-LA.html"
Get-GPOReport -Name "ADSH-STM" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-STM.html"
Get-GPOReport -Name "ADSH-Security" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-Security.html"
Get-GPOReport -Name "Default Domain Policy" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-DefaultDomainPolicy.html"
Get-GPOReport -Name "Default Domain Controllers Policy" -ReportType HTML -Path "C:\ADSH\GPO-Reports\ADSH-DefaultDomainControllersPolicy.html"
Get-GPOReport -Name "GPP-Passwords" -ReportType HTML -Path "C:\ADSH\GPO-Reports\GPP-Passwords.html"

ls



cd c:\ADSH\GPO-Reports

.\ADSH-login.html
.\ADSH-main.html
.\ADSH-main2.html
.\ADSH-ApplockWrite.html
.\ADSH-EnableFirewall.html
.\ADSH-LA.html
.\ADSH-STM.html
.\ADSH-Security.html
.\GPP-Passwords.html


Write-Host "Last step - run Restart-Computer" to restart the computer.
