Get-ADDomain -Identity "adshclass.com" | Select-Object ms-DS-MachineAccountQuota
Set-ADDomain -Identity "adshclass.com" -Replace @{'ms-DS-MachineAccountQuota'=0}
New-ADGroup -Name "SEC_ComputerJoiners" -GroupScope Global -Path "OU=Groups,DC=adshclass,DC=com"
dsacls "OU=Workstations,DC=adshclass,DC=com" /G "adshclass\SEC_ComputerJoiners:CC;computer"