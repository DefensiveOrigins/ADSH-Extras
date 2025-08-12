# 1. Create a new IT admin user
New-ADUser -Name "Morgan Bishop" `
    -GivenName "Morgan" `
    -Surname "Bishop" `
    -SamAccountName "morgan.bishop" `
    -UserPrincipalName "morgan.bishop@adshclass.com" `
    -DisplayName "Morgan Bishop" `
    -Title "IT Admin" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "Str0ngP@ssw0rd!" -AsPlainText -Force) `
    -Enabled $true

# 2. Create a new group for password management delegation
New-ADGroup -Name "SG-Password_Managers" `
    -GroupScope Global `
    -GroupCategory Security `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -Description "Delegated group for password reset rights"

# 3. Add the new user to the password managers group
Add-ADGroupMember -Identity "SG-Password_Managers" -Members "morgan.bishop"

# 4. Delegate permission to reset passwords for all users in ADSHMedical OU
# This uses the Active Directory module and the Active Directory ACL cmdlets
$ou = "OU=ADSHMedical,DC=adshclass,DC=com"
$group = "SG-Password_Managers"

# Get the group SID
$groupObj = Get-ADGroup $group
$groupSid = $groupObj.SID

# Get the OU object
$ouObj = [ADSI]"LDAP://$ou"

# Create a new access rule for resetting passwords
$identity = [System.Security.Principal.SecurityIdentifier]$groupSid
$adRights = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight
$type = [System.DirectoryServices.ActiveAccessControlType]::Allow
$extendedRightGuid = [Guid]"00299570-246d-11d0-a768-00aa006e0529" # Reset Password right

$rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity, $adRights, $type, $extendedRightGuid

# Apply the rule to the OU
$ouObj.psbase.ObjectSecurity.AddAccessRule($rule)
$ouObj.psbase.CommitChanges()
