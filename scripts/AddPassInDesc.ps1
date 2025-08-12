# Create 3 service accounts in IT OU with strong passwords and service ticket references in the description

$serviceAccounts = @(
    @{Sam="svc_BackupAgent"; Display="Backup Service Account"; Password="B@ckupS3rv!2025"; Ticket="SRV-1001"},
    @{Sam="svc_Monitoring"; Display="Monitoring Service Account"; Password="Mon!t0rS3rv#2025"; Ticket="SRV-1002"},
    @{Sam="svc_Deployment"; Display="Deployment Service Account"; Password="D3pl0yS3rv$2025"; Ticket="SRV-1003"}
)

foreach ($sa in $serviceAccounts) {
    $desc = "Password: $($sa.Password); Service Ticket: $($sa.Ticket)"
    New-ADUser -Name $sa.Display `
        -SamAccountName $sa.Sam `
        -UserPrincipalName "$($sa.Sam)@adshclass.com" `
        -DisplayName $sa.Display `
        -Title "Service Account" `
        -Department "IT" `
        -Description $desc `
        -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
        -AccountPassword (ConvertTo-SecureString $sa.Password -AsPlainText -Force) `
        -Enabled $true
}

# Add the backup service account to the Backup Admins group
Add-ADGroupMember -Identity "SG-Backup_Admins" -Members "svc_BackupAgent"
