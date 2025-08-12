# Low Privilege Service Account
New-ADUser -Name "svc_ADSHLowPriv" `
    -SamAccountName "svc_ADSHLowPriv" `
    -UserPrincipalName "svc_ADSHLowPriv@adshclass.com" `
    -DisplayName "ADSH Low Privilege Service Account" `
    -Title "Service Account - Low Privilege" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "S3rv1c3LowP@ss!" -AsPlainText -Force) `
    -Enabled $true

# High Privilege Service Account
New-ADUser -Name "svc_ADSHHighPriv" `
    -SamAccountName "svc_ADSHHighPriv" `
    -UserPrincipalName "svc_ADSHHighPriv@adshclass.com" `
    -DisplayName "ADSH High Privilege Service Account" `
    -Title "Service Account - High Privilege" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString "S3rv1c3HighP@ss!" -AsPlainText -Force) `
    -Enabled $true

# Add high privilege service account to privileged group
Add-ADGroupMember -Identity "SG-Privileged-Admins" -Members "svc_ADSHHighPriv"
