# Ethan Brooks (Medical Assistant) will be our legacy app user
Write-Output "[+] Does Not Require PreAuth"
Set-ADAccountControl -Identity ethan.brooks -DoesNotRequirePreAuth $true

# Assign SPN to Jackson Ford (SysAdmin)
Write-Output "[+] SPN"
Set-ADUser jackson.ford -ServicePrincipalNames @{Add="http/webapp01.adshclass.com"}

# Set password never expires for Olivia Hayes (Nurse)
Write-Output "[+] PasswordNeverExpires"
Set-ADUser olivia.hayes -PasswordNeverExpires $true

# Set for Mia Rivera (Insurance Coordinator)
Write-Output "[+] PasswordNotRequired"
Set-ADUser -Identity mia.rivera -PasswordNotRequired $true

Write-Output "[+] Combination Account"
New-ADUser -Name "svc_legacy" -SamAccountName "svc_legacy" -UserPrincipalName "svc_legacy@adshclass.com" `
  -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) `
  -DisplayName "Legacy Integration Account" -Description "Legacy service account - DO NOT REMOVE" `
  -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Enabled $true

# Set weak flags
Write-Output "[+] Weak Settings"
Set-ADUser svc_legacy -PasswordNeverExpires $true
Set-ADAccountControl -Identity svc_legacy -DoesNotRequirePreAuth $true
Set-ADUser -Identity svc_legacy  -PasswordNotRequired $true
Set-ADUser svc_legacy -ServicePrincipalNames @{Add="HTTP/legacy-api.adshclass.com"}

# Add to Domain Admins group
Write-Output "[+] Domain Admins"
Add-ADGroupMember -Identity "Domain Admins" -Members svc_legacy

Write-Output "[+] Add Computers"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddComputers.ps1"))
Write-Output "[+] DCSync"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddDCSync.ps1"))
Write-Output "[+] DES"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddDES.ps1"))
Write-Output "[+] PasswordNeverExpires"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddNeverExpire.ps1"))
Write-Output "[+] PasswordNotRequired"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddNoPass.ps1"))
Write-Output "[+] Password Disclosure"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddPassInDesc.ps1"))
Write-Output "[+] Pre2k"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddPre2KComp.ps1"))
Write-Output "[+] More users"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddUsers.ps1"))
Write-Output "[+] ChangePW Delegation"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/ChangePass2.ps1"))
Write-Output "[+] Incorrect Jobs"
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/AddIncorrectJobs.ps1"))

Write-Output "[*] Users:"
(Get-ADUser -Filter *).Count
Write-Output "[*] Groups:"
(Get-ADGroup -Filter *).Count
Write-Output "[*] Computers:"
(Get-ADComputer -Filter *).Count
Write-Output "[*] OUs:"
(Get-ADOrganizationalUnit -Filter *).count
Write-Output "[*] Objects:"
(Get-ADObject -Filter *).count

Write-Output "[!] Done"