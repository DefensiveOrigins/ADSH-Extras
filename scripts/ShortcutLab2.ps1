Write-Output "[*] Install DS Features" 
Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Write-Output "[*] Setup Domain" 
Install-ADDSForest -DomainName "ADSHClass.com" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2025" -DomainNetbiosName "ADSHClass" -ForestMode "Win2025"  -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString "ADSHAdmin12345!" -AsPlainText -Force)

Write-Output "[!] Done" 

Restart-Computer
