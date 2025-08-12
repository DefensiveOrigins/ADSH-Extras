# --- create users (as you had) ---

New-ADUser -Name "Alex Harmon" `
  -GivenName "Alex" -Surname "Harmon" `
  -SamAccountName "alex.harmon" `
  -UserPrincipalName "alex.harmon@adshclass.com" `
  -DisplayName "Alex Harmon" -Title "Systems Administrator" `
  -Department "IT" `
  -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
  -AccountPassword (ConvertTo-SecureString "Str0ngP@ssw0rd!2025" -AsPlainText -Force) `
  -Enabled $true

Add-ADGroupMember -Identity "SG-SysAdmin" -Members "alex.harmon"

New-ADUser -Name "ADSync Service Account" `
  -SamAccountName "ADSync" `
  -UserPrincipalName "adsync@adshclass.com" `
  -DisplayName "ADSync Service Account" `
  -Title "Directory Sync Service Account" `
  -Department "IT" `
  -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
  -AccountPassword (ConvertTo-SecureString "S3rv1c3SyncP@ssw0rd!" -AsPlainText -Force) `
  -Enabled $true

Add-ADGroupMember -Identity "SG-SysAdmin" -Members "ADSync"

# Register SPN (use -Add with 'servicePrincipalName')
Set-ADUser -Identity "ADSync" -Add @{ servicePrincipalName = "ADSync/adsync.adshclass.com" }

# --- Grant DCSync (replication) rights on the domain NC ---

# Domain naming context (domain root object)
$domainDN  = (Get-ADRootDSE).defaultNamingContext
$domainObj = [ADSI]"LDAP://$domainDN"

# Replication control access right GUIDs
$guidMap = @{
  'DS-Replication-Get-Changes'                = [Guid]'1131f6aa-9c07-11d1-f79f-00c04fc2dcd2'
  'DS-Replication-Get-Changes-All'            = [Guid]'1131f6ad-9c07-11d1-f79f-00c04fc2dcd2'
  'DS-Replication-Get-Changes-In-Filtered-Set'= [Guid]'89e95b76-444d-4c62-991a-0facbeda640c'
}

$accounts = @('alex.harmon','ADSync')

# Work with the current security descriptor, add ACEs, then write back once
$sd = $domainObj.psbase.ObjectSecurity

foreach ($acct in $accounts) {
  $sid = (Get-ADUser -Identity $acct -Properties SID).SID
  foreach ($guid in $guidMap.Values) {
    $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule `
      ($sid,
       [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
       [System.Security.AccessControl.AccessControlType]::Allow,
       $guid,
       [System.DirectoryServices.ActiveDirectorySecurityInheritance]::None)

    $sd.AddAccessRule($ace) | Out-Null
  }
}

$domainObj.psbase.ObjectSecurity = $sd
$domainObj.SetInfo()
