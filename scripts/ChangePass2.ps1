# 1. Create a new IT admin user
New-ADUser -Name "Stanley Mercer" `
    -GivenName "Stanley" `
    -Surname "Mercer" `
    -SamAccountName "stanley.mercer" `
    -UserPrincipalName "stanley.mercerp@adshclass.com" `
    -DisplayName "Stanley Mercer" `
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
Add-ADGroupMember -Identity "SG-Password_Managers" -Members "stanley.mercer"

# 4. Delegate permission to reset passwords for all users in ADSHMedical OU


<#
Delegate: Reset Password (and pwdLastSet write) for all user objects under an OU
- Grants SG-Password_Managers the "Reset Password" extended right on descendant User objects
- Grants WriteProperty on pwdLastSet so "User must change password at next logon" works
#>

Import-Module ActiveDirectory

$ou    = "OU=ADSHMedical,DC=adshclass,DC=com"
$group = "SG-Password_Managers"

# Resolve group SID
$groupObj = Get-ADGroup -Identity $group -ErrorAction Stop
$groupSid = [System.Security.Principal.SecurityIdentifier]$groupObj.SID

# Resolve schema GUIDs dynamically (environment-safe)
$schemaNC       = (Get-ADRootDSE).schemaNamingContext
$userClassGuid  = (Get-ADObject -SearchBase $schemaNC -LDAPFilter "(lDAPDisplayName=user)" -Properties schemaIDGUID).schemaIDGUID
$pwdLastSetGuid = (Get-ADObject -SearchBase $schemaNC -LDAPFilter "(lDAPDisplayName=pwdLastSet)" -Properties schemaIDGUID).schemaIDGUID

# Extended right GUID (controlAccessRight, safe to hard-code)
$resetPasswordRightGuid = [Guid]"00299570-246d-11d0-a768-00aa006e0529" # Reset Password

# Bind to OU and get current security descriptor
$ouEntry = [ADSI]"LDAP://$ou"
$sec     = $ouEntry.psbase.ObjectSecurity

# Helper: add rule if not already present (idempotent)
function Add-UniqueAce {
    param(
        [Parameter(Mandatory)]
        [System.DirectoryServices.ActiveDirectorySecurity]$Security,

        [Parameter(Mandatory)]
        [System.DirectoryServices.ActiveDirectoryAccessRule]$Rule
    )

    $existing = $Security.GetAccessRules($true, $true, [System.Security.Principal.SecurityIdentifier]) |
        Where-Object {
            $_.IdentityReference   -eq $Rule.IdentityReference   -and
            $_.ActiveDirectoryRights -eq $Rule.ActiveDirectoryRights -and
            $_.AccessControlType   -eq $Rule.AccessControlType   -and
            $_.ObjectType          -eq $Rule.ObjectType          -and
            $_.InheritedObjectType -eq $Rule.InheritedObjectType -and
            $_.InheritanceType     -eq $Rule.InheritanceType
        }

    if (-not $existing) {
        [void]$Security.AddAccessRule($Rule)
        return $true
    }
    return $false
}

# 1) Reset Password on descendant user objects
$ruleReset = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSid,
    [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $resetPasswordRightGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $userClassGuid
)

# 2) Write 'pwdLastSet' on descendant user objects
$rulePwdLastSet = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $groupSid,
    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
    [System.Security.AccessControl.AccessControlType]::Allow,
    $pwdLastSetGuid,
    [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
    $userClassGuid
)

# (Optional) Also allow unlocking by writing lockoutTime
# $lockoutTimeGuid = (Get-ADObject -SearchBase $schemaNC -LDAPFilter "(lDAPDisplayName=lockoutTime)" -Properties schemaIDGUID).schemaIDGUID
# $ruleLockout = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
#     $groupSid,
#     [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty,
#     [System.Security.AccessControl.AccessControlType]::Allow,
#     $lockoutTimeGuid,
#     [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents,
#     $userClassGuid
# )

# Apply rules (boolean OR done the PowerShell way)
$changed = $false
if (Add-UniqueAce -Security $sec -Rule $ruleReset)      { $changed = $true }
if (Add-UniqueAce -Security $sec -Rule $rulePwdLastSet) { $changed = $true }
# if (Add-UniqueAce -Security $sec -Rule $ruleLockout)    { $changed = $true }  # optional

if ($changed) {
    $ouEntry.psbase.ObjectSecurity = $sec
    $ouEntry.psbase.CommitChanges()
} else {
}
