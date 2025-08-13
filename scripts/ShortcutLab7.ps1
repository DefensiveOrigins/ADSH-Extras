cd c:\ADSH
get-adgroupmember 'enterprise admins' | select name,samaccountname
get-adgroupmember 'schema admins' | select name,samaccountname
get-adgroupmember 'domain admins' | select name,samaccountname
get-adgroupmember 'administrators' | select name,samaccountname
get-adgroupmember 'Hyper-V Administrators' | select name,samaccountname

cd c:\ADSH
get-adgroupmember 'Server Operators' | select name,samaccountname
get-adgroupmember 'Account Operators' | select name,samaccountname
get-adgroupmember 'Backup Operators' | select name,samaccountname
get-adgroupmember 'Cert Publishers' | select name,samaccountname
get-adgroupmember 'Key Admins' | select name,samaccountname
get-adgroupmember 'Enterprise Key Admins' | select name,samaccountname

cd c:\ADSH
get-adgroupmember 'Remote Desktop Users' | select name,samaccountname

cd c:\ADSH
get-adgroupmember 'Pre-Windows 2000 Compatible Access' | select name,samaccountname
get-adgroupmember 'Protected Users' | select name,samaccountname

cd c:\ADSH
get-adgroupmember 'Domain Controllers' | select name,samaccountname
get-adgroupmember 'Read-only Domain Controllers' | select name,samaccountname
get-adgroupmember 'Enterprise Read-only Domain Controllers' | select name,samaccountname

cd c:\ADSH
# Passwords that Never Expire
get-aduser -filter * -properties passwordlastset, passwordneverexpires | where {$_.passwordNeverExpires -eq "true" } | ft Name, passwordlastset, Passwordneverexpires

# Cannot Change Password
get-aduser -filter * -properties passwordlastset, cannotchangepassword | where {$_.cannotchangepassword -eq "true" } | ft Name, passwordlastset, cannotchangepassword

#Password is Expired
get-aduser -filter * -properties passwordlastset, PasswordExpired | where {$_.PasswordExpired -eq "true" } | ft Name, passwordlastset, PasswordExpired

#Password is Not Required
get-aduser -filter * -properties passwordlastset, PasswordNotRequired | where {$_.PasswordNotRequired -eq "true" } | ft Name, passwordlastset, PasswordNotRequired

#Account is Locked Out
get-aduser -filter * -properties passwordlastset, LockedOut | where {$_.LockedOut -eq "true" } | ft Name, passwordlastset, LockedOut

#User is Critical System Object
get-aduser -filter * -properties passwordlastset, isCriticalSystemObject | where {$_.isCriticalSystemObject -eq "true" } | ft Name, passwordlastset, isCriticalSystemObject

# User is Protected from Accidental Deletion
get-aduser -filter * -properties passwordlastset, ProtectedFromAccidentalDeletion | where {$_.ProtectedFromAccidentalDeletion -eq "true" } | ft Name, passwordlastset, ProtectedFromAccidentalDeletion

#User has Never Logged on (Limited to 25 results)
get-aduser -filter * -properties passwordlastset, logonCount | where {$_.logonCount -eq 0 } | Select-Object -first 25 |  ft Name, passwordlastset, logonCount

#Admin Count is set
get-aduser -filter * -properties passwordlastset, AdminCount | where {$_.AdminCount -eq 1 } | ft Name, passwordlastset, AdminCoun

cd c:\ADSH

#Password Stored in Reversible Encryption
get-aduser -filter * -properties passwordlastset, AllowReversiblePasswordEncryption | where {$_.AllowReversiblePasswordEncryption -eq "true" } | ft Name, passwordlastset, AllowReversiblePasswordEncryption

#Authentication uses DES Key Only
get-aduser -filter * -properties passwordlastset, UseDESKeyOnly | where {$_.UseDESKeyOnly -eq "true" } | ft Name, passwordlastset, UseDESKeyOnly

# User Does Not Require Pre-Authentication
get-aduser -filter * -properties passwordlastset, DoesNotRequirePreAuth | where {$_.DoesNotRequirePreAuth -eq "true" } | ft Name, passwordlastset, DoesNotRequirePreAuth

cd c:\ADSH

#Account is Trusted for Delegation
get-aduser -filter * -properties passwordlastset, TrustedForDelegation | where {$_.TrustedForDelegation -eq "true" } | ft Name, passwordlastset, TrustedForDelegation

#Trusted to Authenticate for Delegation
get-aduser -filter * -properties passwordlastset, TrustedToAuthForDelegation | where {$_.TrustedToAuthForDelegation -eq "true" } | ft Name, passwordlastset, TrustedToAuthForDelegation

# Account is Not Delegated
get-aduser -filter * -properties passwordlastset, AccountNotDelegated | where {$_.AccountNotDelegated -eq "true" } | ft Name, passwordlastset, AccountNotDelegated

cd c:\ADSH

#User objects with SPN
get-aduser -filter * -properties passwordlastset, servicePrincipalName | where {$_.servicePrincipalName -NE "" - 1 } | ft Name, passwordlastset, servicePrincipalName

#Computer Objects with SPN
get-adcomputer -filter * -properties passwordlastset, servicePrincipalName | where {$_.servicePrincipalName -NE "" - 1 } | ft Name, passwordlastset, servicePrincipalName





#Setup a Report Destination
cd c:\ADSH
New-Item -ItemType Directory -Path "C:\ADSH\PSReports" -Force > $null

#Setup a Report Engine
Import-Module Microsoft.PowerShell.Utility
$Header = "<style>TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;} TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;} TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;} </style>"
$SelectProps = "SamAccountName","DistinguishedName","SID",@{N="SPN_List";E={$_.servicePrincipalName -join ","}},"PasswordLastSet","Enabled","TrustedForDelegation","TrustedToAuthForDelegation","UseDESKeyOnly","ProtectedFromAccidentalDeletion","PasswordNotRequired","PasswordNeverExpires","PasswordExpired","CannotChangePassword","DoesNotRequirePreAuth","LockedOut","AccountNotDelegated","AllowReversiblePasswordEncryption","isCriticalSystemObject","logonCount","AdminCount",@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}}

$REPPath = "c:\ADSH\PSReports\"

#Build Reports for Group Membership
$ReportGroups="domain admins","schema admins","Enterprise admins","administrators","Hyper-V Administrators","Server Operators","Account Operators","Backup Operators","Cert Publishers","Key Admins","Remote Desktop Users","Pre-Windows 2000 Compatible Access","Protected Users","Read-only Domain Controllers","Enterprise Read-only Domain Controllers","Domain Controllers"
foreach($ReportGroup in $ReportGroups) {$rp++;write-progress -Activity "Generating Report $ReportGroup" -PercentComplete (($rp/$ReportGroups.count)*100); (get-adgroupmember $ReportGroup -Recursive | where objectClass -eq "user" | get-aduser -properties * |select $SelectProps| ConvertTo-Html -PreContent "<H1>$ReportGroup User Members</H1>$Header" -Fragment),@(get-adgroupmember $ReportGroup -Recursive | where objectClass -eq "computer" | get-adcomputer -properties * |select $SelectProps| ConvertTo-Html -PreContent "<H1>$ReportGroup Computer Members</H1>$Header" -Fragment)| Out-File $REPPath"Group_"$ReportGroup".html" };$rp=0

#Build User Attribute Reports
$ReportAttribs="passwordNeverExpires","CannotChangePassword","PasswordExpired","PasswordNotRequired","LockedOut","isCriticalSystemObject","ProtectedFromAccidentalDeletion","NeverLoggedOn","AllowReversiblePasswordEncryption","UseDESKeyOnly","DoesNotRequirePreAuth","TrustedForDelegation","TrustedToAuthForDelegation","AccountNotDelegated"
foreach($ReportAttrib in $ReportAttribs) {$ra++;write-progress -Activity "Generating Report $ReportAttrib" -PercentComplete (($ra/$ReportAttribs.count)*100); (get-aduser -filter * -properties * | where {$_.$ReportAttrib -eq "true" } | select $SelectProps |  ConvertTo-Html -PreContent "<H1>$ReportAttrib - Users</H1>$Header" -Fragment),(get-adcomputer -filter * -properties * | where {$_.$ReportAttrib -eq "true" } | select $SelectProps |  ConvertTo-Html -PreContent "<H1>$ReportAttrib - Computers</H1>$Header" -Fragment) | Out-File $REPPath"Attrib-$ReportAttrib.html"};$ra=0

#Never Logged On
(get-aduser -filter * -properties * | where {$_.logonCount -eq 0 } | select $SelectProps |  ConvertTo-Html -PreContent "<H1>Never Logged On - Users</H1>$Header" -Fragment),(get-adcomputer -filter * -properties * | where {$_.logonCount -eq 0} | select $SelectProps |  ConvertTo-Html -PreContent "<H1>Never Logged On - Computers</H1>$Header" -Fragment) | Out-File $REPPath"Attrib-NeverLoggedOn.html"

#AdminCount
(get-aduser -filter * -properties * | where {$_.AdminCount -eq 1} | select $SelectProps |  ConvertTo-Html -PreContent "<H1>Admin Count - Users</H1>$Header" -Fragment),(get-adcomputer -filter * -properties * | where {$_.AdminCount -eq 1} | select $SelectProps |  ConvertTo-Html -PreContent "<H1>Admin Count - Computers</H1>$Header" -Fragment) | Out-File $REPPath"Attrib-AdminCount.html"
 
 #Service Principal Names
 (get-aduser -filter * -properties * | where {$_.servicePrincipalName -NE ""} | select $SelectProps |  ConvertTo-Html -PreContent "<H1>ServicePrincipalNames - Users</H1>$Header" -Fragment),(get-adcomputer -filter * -properties * | where {$_.servicePrincipalName -NE ""} | select $SelectProps |  ConvertTo-Html -PreContent "<H1>ServicePrincipalNames - Computers</H1>$Header" -Fragment) | Out-File $REPPath"Attrib-servicePrincipalName.html"


#clear all our variables
cd c:\ADSH\PSReports
ls

