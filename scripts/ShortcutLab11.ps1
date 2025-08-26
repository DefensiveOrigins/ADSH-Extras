 Write-Output "[*] Get ADCS" 
Get-WindowsFeature -Name AD-Certificate | Install-WindowsFeature
 Write-Output "[*] Install ADCS" 
Install-AdcsCertificationAuthority -CAType StandaloneRootCA -Force
 Write-Output "[*] Get ADCS Tools" 
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools

 Write-Output "[*] Setup Lab" 

New-Item -ItemType Directory -Path "C:\ADSH\ADCS\" -Force > $null
cd C:\ADSH\ADCS\
$wc = new-object System.Net.WebClient
$wc.DownloadFile('https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/ADCS/ADSH_Computer.json', 'C:\ADSH\ADCS\ADSHLab_Computer.json')
$wc.DownloadFile('https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/ADCS/ADSH_User.json', 'C:\ADSH\ADCS\ADSHLab_User.json')

ls C:\ADSH\ADCS\ | Select-Object Name, Length

 Write-Output "[*] Install Templates" 

Install-Module ADCSTemplate -Force
New-ADCSTemplate -DisplayName ADSHLab_Computer -JSON (Get-Content C:\ADSH\ADCS\ADSHLab_Computer.json -Raw) -Publish
New-ADCSTemplate -DisplayName ADSHLab_User -JSON (Get-Content C:\ADSH\ADCS\ADSHLab_User.json -Raw) -Publish
Set-ADCSTemplateACL -DisplayName ADSHLab_Computer  -Enroll -Identity 'ADSHClass\Domain Computers'
Set-ADCSTemplateACL -DisplayName ADSHLab_User  -Enroll -Identity 'ADSHClass\Domain Users'

 Write-Output "[*] Get PSPKIAudit" 


wget https://github.com/DefensiveOrigins/PSPKIAudit/archive/refs/heads/main.zip -O PSPKIAudit.zip
Expand-Archive PSPKIAudit.zip
ls  | Select-Object Name, Length

 Write-Output "[*] Run Audit" 


cd C:\ADSH\ADCS\PSPKIAudit\PSPKIAudit-main
Get-ChildItem -Recurse | Unblock-File
Install-Module -Name PSPKI -Force
Import-Module .\PSPKIAudit.psd1

Invoke-PKIAudit | Tee-Object -FilePath "C:\ADSH\ADCS\PSPKIAudit-Report.txt"

ls C:\ADSH\ADCS\ | Select-Object Name, Length

 Write-Output "[!] Done" 

