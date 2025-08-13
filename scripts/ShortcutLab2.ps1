Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "ADSHClass.com" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "Win2025" -DomainNetbiosName "ADSHClass" -ForestMode "Win2025"  -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$True -SysvolPath "C:\Windows\SYSVOL" -Force:$true
Restart-Computer
