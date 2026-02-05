Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota
Set-ADDomain -Identity "adshclass.com" -Replace @{'ms-DS-MachineAccountQuota'=0}}
Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota
New-ADGroup -Name "SEC_ComputerJoiners" -GroupScope Global -Path "OU=Groups,DC=adshclass,DC=com"
Write-Output "[*] Get MAQ" 
Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota
Write-Output "[*] Set MAQ"
Set-ADDomain -Identity "adshclass.com" -Replace @{'ms-DS-MachineAccountQuota'=0}
Write-Output "[*] Get MAQ" 
Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota
Write-Output "[+] Create Group"
New-ADGroup -Name "SEC_ComputerJoiners" -GroupScope Global -Path "OU=ADSHMedical,DC=adshclass,DC=com"
Write-Output "[+] Delegate" 
dsacls "OU=Workstations,DC=adshclass,DC=com" /G "adshclass\SEC_ComputerJoiners:CC;computer"

Write-Output "[+] Check OU for new Computers"
Get-ADDomain | Select-Object ComputersContainer
Write-Output "[+] Change ComputersContainer to Medical OU"
redircmp "OU=ADSHMedical,DC=adshclass,DC=com"
Write Output "[+] Verify Change"
Get-ADDomain | Select-Object ComputersContainer
Write-Output "[+] Create Test Computer Account"
New-ADComputer -Name NewComputer1 -SamAccountName NewComputer1
Get-ADComputer -Identity NewComputer1 | Select-Object DistinguishedName


Write-Output "[!] Done" 
