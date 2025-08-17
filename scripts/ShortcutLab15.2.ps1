New-ADOrganizationalUnit -Name "SecurityGroups" -Path "DC=ADSHClass,DC=com"
New-ADOrganizationalUnit -Name "ComputerAccounts" -Path "DC=ADSHClass,DC=com"
New-ADOrganizationalUnit -Name "GMSAGroups" -Path "OU=SecurityGroups,DC=ADSHClass,DC=com"
New-ADGroup "sec_gmsa_BillsReportingService" -Path "OU=GMSAGroups,OU=SecurityGroups,DC=ADSHClass,dc=com" -GroupCategory Security -GroupScope DomainLocal -PassThru –Verbose
New-ADComputer -Name "svr_BillsReporter" -SamAccountName "svr_BillsReporter" -Path "OU=ComputerAccounts,DC=ADSHClass,DC=com"

ADD-ADGroupMember “sec_gmsa_BillsReportingService” –members “svr_BillsReporter$”
ADD-ADGroupMember “sec_gmsa_BillsReportingService” –members “adsh-dc1$”

Add-KdsRootKey –EffectiveTime ((get-date).addhours(-10))     

New-ADOrganizationalUnit -Name "GMSAs" -Path "DC=adshclass,DC=com"

New-ADServiceAccount -name gmsa_bobrep -PrincipalsAllowedToRetrieveManagedPassword sec_gmsa_BillsReportingService -path "OU=GMSAs,dc=adshclass,dc=com" -DNSHostName gmsa_bobrep$

New-Item -ItemType Directory -Path "C:\ADSH\GMSA" -Force > $null
cd c:\ADSH\GMSA
echo "" | Out-File log.txt -Encoding ASCII
"whoami >>c:\ADSH\GMSA\log.txt" |Out-File gmsalog.bat -Encoding ASCII
"echo %time% >>c:\ADSH\GMSA\log.txt" |Out-File gmsalog.bat -Append -Encoding ASCII

cd c:\ADSH\GMSA
./gmsalog.bat
cat log.txt

$acl = Get-Acl c:\ADSH\GMSA
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("adshclass\gmsa_bobrep$","FullControl","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl c:\ADSH\GMSA
$acl | Set-Acl c:\ADSH\GMSA\gmsalog.bat
$acl | Set-Acl c:\ADSH\GMSA\log.txt


Restart-Computer

