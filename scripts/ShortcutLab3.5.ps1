# Ethan Brooks (Medical Assistant) will be our legacy app user
Set-ADAccountControl -Identity ethan.brooks -DoesNotRequirePreAuth $true

# Assign SPN to Jackson Ford (SysAdmin)
Set-ADUser jackson.ford -ServicePrincipalNames @{Add="http/webapp01.adshclas"}

# Set password never expires for Olivia Hayes (Nurse)
Set-ADUser olivia.hayes -PasswordNeverExpires $true

# Set for Mia Rivera (Insurance Coordinator)
Set-ADUser -Identity mia.rivera -PasswordNotRequired $true

New-ADUser -Name "svc_legacy" -SamAccountName "svc_legacy" -UserPrincipalName "svc_legacy@adshclass.com" `
  -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) `
  -DisplayName "Legacy Integration Account" -Description "Legacy service account - DO NOT REMOVE" `
  -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Enabled $true

# Set weak flags
Set-ADUser svc_legacy -PasswordNeverExpires $true
Set-ADAccountControl -Identity svc_legacy -DoesNotRequirePreAuth $true
Set-ADUser -Identity svc_legacy  -PasswordNotRequired $true
Set-ADUser svc_legacy -ServicePrincipalNames @{Add="HTTP/legacy-api.adshclass.com"}

# Add to Domain Admins group
Add-ADGroupMember -Identity "Domain Admins" -Members svc_legacy

iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddComputers.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddDCSync.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddDES.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddIncorrectJobs.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddNeverExpire.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddNoPass.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddPassInDesc.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddPre2KComp.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddUsers.ps1"))
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/ChangePass2.ps1"))


(Get-ADUser -Filter *).Count
(Get-ADGroup -Filter *).Count
(Get-ADComputer -Filter *).Count
(Get-ADOrganizationalUnit -Filter *).count
(Get-ADObject -Filter *).count

