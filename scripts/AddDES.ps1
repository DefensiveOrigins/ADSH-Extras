# Create SG-Privileged-Admins group if it does not exist
if (-not (Get-ADGroup -Filter { Name -eq "SG-Privileged-Admins" } -ErrorAction SilentlyContinue)) {
    New-ADGroup -Name "SG-Privileged-Admins" `
        -SamAccountName "SG-Privileged-Admins" `
        -GroupScope Global `
        -GroupCategory Security `
        -Path "OU=ADSHMedical,DC=adshclass,DC=com" `
        -Description "Privileged administrative accounts with high-level permissions"
}

# Low Privilege Service Account
New-ADUser -Name "svc_ADSHLowPriv" `
    -SamAccountName "svc_ADSHLowPriv" `
    -UserPrincipalName "svc_ADSHLowPriv@adshclass.com" `
    -DisplayName "ADSH Low Privilege Service Account" `
    -Title "Service Account - Low Privilege" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "Qd5Lt1w78uZy8vpV" -AsPlainText -Force) `
    -Enabled $true

# High Privilege Service Account
New-ADUser -Name "svc_ADSHHighPriv" `
    -SamAccountName "svc_ADSHHighPriv" `
    -UserPrincipalName "svc_ADSHHighPriv@adshclass.com" `
    -DisplayName "ADSH High Privilege Service Account" `
    -Title "Service Account - High Privilege" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "1DsLD061aIVFv2bJ" -AsPlainText -Force) `
    -Enabled $true

# Add high privilege service account to privileged group
Add-ADGroupMember -Identity "SG-Privileged-Admins" -Members "svc_ADSHHighPriv"

# Add reversible encryption
New-ADUser -Name "Tyler Carter" -GivenName "Tyler" -Surname "Carter" -SamAccountName "tyler.carter" -UserPrincipalName "tyler.carter@adshclass.com" -DisplayName "Tyler Carter" -Title "Help Desk Technician" -Department "IT" -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "SG-Help_Desk" -Members tyler.carter
Set-ADUser -Identity "tyler.carter" -AllowReversiblePasswordEncryption $true

# accidental delection
Set-ADObject -Identity "tyler.carter" -ProtectedFromAccidentalDeletion:$true


# add DESOnly
New-ADUser -Name "Samantha Hollec" -GivenName "Samantha" -Surname "Hollec" -SamAccountName "samantha.hollec" -UserPrincipalName "samantha.hollec@adshclass.com" -DisplayName "Samantha Hollec" -Title "Help Desk Technician" -Department "IT" -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "SG-Help_Desk" -Members samantha.hollec
Set-ADAccountControl -Identity samantha.hollec -UseDESKeyOnly $true


# cannot change password
New-ADUser -Name "Chris Cortez" -GivenName "Chris" -Surname "Cortez" -SamAccountName "chris.cortez" -UserPrincipalName "chris.cortez@adshclass.com" -DisplayName "Chris Cortez" -Title "Medical Coder" -Department "Billing & Records" -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "SG-Medical_Coder" -Members chris.cortez
Set-ADUser -Identity "chris.cortez" -CannotChangePassword $true

# trusted  for delegation
Set-ADAccountControl -Identity "chris.cortez" -TrustedForDelegation $true

#trusted toauthfordel
New-ADUser -Name "Jack Jacobs" -GivenName "Jack" -Surname "Jacobs" -SamAccountName "jack.jacobs" -UserPrincipalName "jack.jacobs@adshclass.com" -DisplayName "Jack Jacobs" -Title "Medical Coder" -Department "Billing & Records" -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "SG-Medical_Coder" -Members jack.jacobs
Set-ADAccountControl -Identity "jack.jacobs" -TrustedToAuthForDelegation $True

#account not delegated
New-ADUser -Name "Meredith Blakenship" -GivenName "Meredith" -Surname "Blakenship" -SamAccountName "meredith.blackenship" -UserPrincipalName "meredith.blackenship@adshclass.com" -DisplayName "Meredith Blakenship" -Title "Medical Coder" -Department "Billing & Records" -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
Add-ADGroupMember -Identity "SG-Medical_Coder" -Members meredith.blackenship
Set-ADAccountControl -Identity "meredith.blackenship" -AccountNotDelegated $true
