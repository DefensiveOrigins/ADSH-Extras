Get-WindowsFeature -Name AD-Certificate | Install-WindowsFeature
Install-AdcsCertificationAuthority -CAType StandaloneRootCA
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools

New-Item -ItemType Directory -Path "C:\ADSH\ADCS\" -Force > $null
cd C:\ADSH\ADCS\
$wc = new-object System.Net.WebClient
$wc.DownloadFile('https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/ADCS/DOAZLab_Computer.json', 'C:\ADSH\ADCS\ADSHLab_Computer.json')
$wc.DownloadFile('https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/ADCS/DOAZLab_User.json', 'C:\ADSH\ADCS\ADSHLab_User.json')
ls C:\ADSH\ADCS\ | Select-Object Name, Length

Install-Module ADCSTemplate -Force
New-ADCSTemplate -DisplayName ADSHLab_Computer -JSON (Get-Content C:\ADSH\ADCS\ADSHLab_Computer.json -Raw) -Publish
New-ADCSTemplate -DisplayName ADSHLab_User -JSON (Get-Content C:\ADSH\ADCS\ADSHLab_User.json -Raw) -Publish
Set-ADCSTemplateACL -DisplayName ADSHLab_Computer  -Enroll -Identity 'ADSHClass\Domain Computers'
Set-ADCSTemplateACL -DisplayName ADSHLab_User  -Enroll -Identity 'ADSHClass\Domain Users'


wget https://github.com/DefensiveOrigins/PSPKIAudit/archive/refs/heads/main.zip -O PSPKIAudit.zip
Expand-Archive PSPKIAudit.zip
ls  | Select-Object Name, Length


cd C:\ADSH\ADCS\PSPKIAudit\PSPKIAudit-main
Get-ChildItem -Recurse | Unblock-File
Install-Module -Name PSPKI -Force
Import-Module .\PSPKIAudit.psd1


Invoke-PKIAudit | Tee-Object -FilePath "C:\ADSH\ADCS\PSPKIAudit-Report.txt"
ls C:\ADSH\ADCS\ | Select-Object Name, Length

