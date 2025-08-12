# Create a new IT administrator user
New-ADUser -Name "Alex Harmon" `
    -GivenName "Alex" `
    -Surname "Harmon" `
    -SamAccountName "alex.harmon" `
    -UserPrincipalName "alex.harmon@adshclass.com" `
    -DisplayName "Alex Harmon" `
    -Title "Systems Administrator" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "Str0ngP@ssw0rd!2025" -AsPlainText -Force) `
    -Enabled $true

# Add to SysAdmin group
Add-ADGroupMember -Identity "SG-SysAdmin" -Members "alex.harmon"

# Create a new service account with SPN
New-ADUser -Name "ADSync Service Account" `
    -SamAccountName "ADSync" `
    -UserPrincipalName "adsync@adshclass.com" `
    -DisplayName "ADSync Service Account" `
    -Title "Directory Sync Service Account" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "S3rv1c3SyncP@ssw0rd!" -AsPlainText -Force) `
    -Enabled $true

# Add to SysAdmin group
Add-ADGroupMember -Identity "SG-SysAdmin" -Members "ADSync"

# Register an SPN for the service account
Set-ADUser -Identity "ADSync" -ServicePrincipalNames @{Add="ADSync/adsync.adshclass.com"}

# Grant DCSync permissions to both accounts
$domainDn = (Get-ADDomain).DistinguishedName
$accounts = @("alex.harmon", "ADSync")
$rights = @(
    "DS-Replication-Get-Changes",                # Replicating Directory Changes
    "DS-Replication-Get-Changes-All",            # Replicating Directory Changes All
    "DS-Replication-Get-Changes-In-Filtered-Set" # Replicating Directory Changes In Filtered Set
)

foreach ($account in $accounts) {
    $sid = (Get-ADUser $account).SID
    foreach ($right in $rights) {
        $ace = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "ExtendedRight", "Allow", $right
        $domainObj = [ADSI]"LDAP://$domainDn"
        $domainObj.psbase.ObjectSecurity.AddAccessRule($ace)
        $domainObj.psbase.CommitChanges()
    }
}
