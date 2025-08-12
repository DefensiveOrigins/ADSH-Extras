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
    -AccountPassword (ConvertTo-SecureString "S3rv1c3LowP@ss!Now!" -AsPlainText -Force) `
    -Enabled $true

# High Privilege Service Account
New-ADUser -Name "svc_ADSHHighPriv" `
    -SamAccountName "svc_ADSHHighPriv" `
    -UserPrincipalName "svc_ADSHHighPriv@adshclass.com" `
    -DisplayName "ADSH High Privilege Service Account" `
    -Title "Service Account - High Privilege" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "S3rv1c3HighP@ss!Later!" -AsPlainText -Force) `
    -Enabled $true

# Add high privilege service account to privileged group
Add-ADGroupMember -Identity "SG-Privileged-Admins" -Members "svc_ADSHHighPriv"
