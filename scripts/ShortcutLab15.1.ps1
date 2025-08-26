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
Write-Output "[!] Done" 
