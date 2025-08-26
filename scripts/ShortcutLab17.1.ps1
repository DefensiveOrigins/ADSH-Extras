Write-Output "Setting Up."
New-Item -ItemType Directory -Path "C:\ADSH\KeyCred\" -Force > $null
cd C:\ADSH\KeyCred\
Write-Output "Get Script."
Import-Module ActiveDirectory 
iwr -Uri https://github.com/DefensiveOrigins/Set-AuditRule/raw/refs/heads/master/Set-AuditRule.ps1 -OutFile Set-AuditRule.ps1
Import-Module .\Set-AuditRule.ps1
Write-Output "Set Audit Rule"
Set-AuditRule -AdObjectPath 'AD:\OU=ADSHMedical,DC=adshclass,DC=com' -WellKnownSidType WorldSid -Rights WriteProperty,GenericWrite -InheritanceFlags Children -AttributeGUID 5b47d60f-6090-40b2-9f37-2a4de88f3063 -AuditFlags Success
Write-Output "Done"