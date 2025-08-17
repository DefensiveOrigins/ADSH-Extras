Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota
Set-ADDomain -Identity "adshclass.com" -Replace @{'ms-DS-MachineAccountQuota'=0}}
Get-ADObject ((Get-ADDomain).distinguishedname) -Properties ms-DS-MachineAccountQuota
New-ADGroup -Name "SEC_ComputerJoiners" -GroupScope Global -Path "OU=Groups,DC=adshclass,DC=com"
dsacls "OU=Workstations,DC=adshclass,DC=com" /G "adshclass\SEC_ComputerJoiners:CC;computer"