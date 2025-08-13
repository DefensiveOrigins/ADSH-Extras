# Create root OU
New-ADOrganizationalUnit -Name "ADSHMedical" -Path "DC=adshclass,DC=com"

# Create Departmental OUs
New-ADOrganizationalUnit -Name "Administration" -Path "OU=ADSHMedical,DC=adshclass,DC=com"
New-ADOrganizationalUnit -Name "ClinicalServices" -Path "OU=ADSHMedical,DC=adshclass,DC=com"
New-ADOrganizationalUnit -Name "IT" -Path "OU=ADSHMedical,DC=adshclass,DC=com"
New-ADOrganizationalUnit -Name "BillingAndRecords" -Path "OU=ADSHMedical,DC=adshclass,DC=com"
New-ADOrganizationalUnit -Name "FacilitiesAndSupport" -Path "OU=ADSHMedical,DC=adshclass,DC=com"

New-ADGroup -Name "SG-HR_Specialist"        -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for HR Specialist"
New-ADGroup -Name "SG-Executive_Assistant"  -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Executive Assistant"
New-ADGroup -Name "SG-Office_Manager"       -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Office Manager"

New-ADGroup -Name "SG-Doctor"              -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Doctors"
New-ADGroup -Name "SG-Nurse"               -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Nurses"
New-ADGroup -Name "SG-Medical_Assistant"   -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Medical Assistants"

New-ADGroup -Name "SG-Help_Desk"           -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Help Desk Technicians"
New-ADGroup -Name "SG-SysAdmin"            -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for System Administrators"
New-ADGroup -Name "SG-Security_Analyst"    -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Security Analysts"

New-ADGroup -Name "SG-Medical_Coder"         -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Medical Coders"
New-ADGroup -Name "SG-Insurance_Coordinator" -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Insurance Coordinators"
New-ADGroup -Name "SG-Records_Clerk"         -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Records Clerks"

New-ADGroup -Name "SG-Maintenance"      -GroupScope Global -GroupCategory Security -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Maintenance Staff"
New-ADGroup -Name "SG-Security_Guard"   -GroupScope Global -GroupCategory Security -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Security Guards"
New-ADGroup -Name "SG-Janitor"          -GroupScope Global -GroupCategory Security -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Security group for Janitorial Staff"

New-ADGroup -Name "SG-All-Administration"       -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "All administrative staff"
New-ADGroup -Name "SG-All-ClinicalServices"     -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "All clinical staff"
New-ADGroup -Name "SG-All-IT"                   -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "All IT staff"
New-ADGroup -Name "SG-All-BillingAndRecords"    -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "All billing and records staff"
New-ADGroup -Name "SG-All-FacilitiesAndSupport" -GroupScope Global -GroupCategory Security -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -Description "All support/facilities staff"

Add-ADGroupMember -Identity "SG-All-Administration" -Members "SG-HR_Specialist","SG-Executive_Assistant","SG-Office_Manager"
Add-ADGroupMember -Identity "SG-All-ClinicalServices" -Members "SG-Doctor","SG-Nurse","SG-Medical_Assistant"
Add-ADGroupMember -Identity "SG-All-IT" -Members "SG-Help_Desk","SG-SysAdmin","SG-Security_Analyst"
Add-ADGroupMember -Identity "SG-All-BillingAndRecords" -Members "SG-Medical_Coder","SG-Insurance_Coordinator","SG-Records_Clerk"
Add-ADGroupMember -Identity "SG-All-FacilitiesAndSupport" -Members "SG-Maintenance","SG-Security_Guard","SG-Janitor"

New-ADGroup -Name "SG-All-ADSHStaff" -GroupScope Global -GroupCategory Security -Path "OU=ADSHMedical,DC=adshclass,DC=com" -Description "All ADSH Medical Group staff"

Add-ADGroupMember -Identity "SG-All-ADSHStaff" -Members ` "SG-All-Administration", "SG-All-ClinicalServices", "SG-All-IT",   "SG-All-BillingAndRecords", "SG-All-FacilitiesAndSupport"

# Allow print access to specific physical printer zones
New-ADGroup -Name "SG-RESOURCE-Print-AdminWing"      -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to Admin Wing network printer"
New-ADGroup -Name "SG-RESOURCE-Print-Clinical1stFlr" -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to 1st Floor Clinical printer"
New-ADGroup -Name "SG-RESOURCE-Print-RecordsDept"    -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to Billing/Records printer"

# Groups granted RDP access to specific server roles or zones
New-ADGroup -Name "SG-RESOURCE-RDP-ClinicianVMs"   -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "RDP access to clinician virtual desktops"
New-ADGroup -Name "SG-RESOURCE-RDP-ITServers"      -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "RDP access to infrastructure servers"
New-ADGroup -Name "SG-RESOURCE-RDP-TrainingLab"    -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "RDP access to training lab machines"

# Departmental or project-based shared drives
New-ADGroup -Name "SG-RESOURCE-FS-ClinicalDocs"     -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to shared clinical documentation"
New-ADGroup -Name "SG-RESOURCE-FS-BillingRecords"   -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to billing and financial records"
New-ADGroup -Name "SG-RESOURCE-FS-ITTools"          -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to IT tools and scripts repository"

# Shared resource/security access
New-ADGroup -Name "SG-RESOURCE-PS-TranscriptionTool" -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to shared transcription software"
New-ADGroup -Name "SG-RESOURCE-VPN-Access"           -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to VPN service"
New-ADGroup -Name "SG-RESOURCE-PowerBI-Reporting"    -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to PowerBI reporting workspace"

# Create groups
New-ADGroup -Name "SG-RESOURCE-FS-AdminDocs"         -GroupScope Global -GroupCategory Security -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to admin department shared folder"
New-ADGroup -Name "SG-RESOURCE-App-ClinicalEMR"      -GroupScope Global -GroupCategory Security -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to Clinical EMR system"
New-ADGroup -Name "SG-RESOURCE-Print-ITWing"         -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to secure IT printer"
New-ADGroup -Name "SG-RESOURCE-FS-BillingDrive"      -GroupScope Global -GroupCategory Security -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to billing documents"
New-ADGroup -Name "SG-RESOURCE-App-FacilitiesPortal" -GroupScope Global -GroupCategory Security -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Access to Facilities maintenance portal"


# Add membership
Add-ADGroupMember -Identity "SG-RESOURCE-FS-AdminDocs"         -Members "SG-All-Administration"
Add-ADGroupMember -Identity "SG-RESOURCE-App-ClinicalEMR"      -Members "SG-All-ClinicalServices"
Add-ADGroupMember -Identity "SG-RESOURCE-Print-ITWing"         -Members "SG-All-IT"
Add-ADGroupMember -Identity "SG-RESOURCE-FS-BillingDrive"      -Members "SG-All-BillingAndRecords"
Add-ADGroupMember -Identity "SG-RESOURCE-App-FacilitiesPortal" -Members "SG-All-FacilitiesAndSupport"

# Create Groups

New-ADGroup -Name "SG-RESOURCE-VPN-AllStaff"         -GroupScope Global -GroupCategory Security -Path "OU=ADSHMedical,DC=adshclass,DC=com" -Description "VPN access for all staff"
New-ADGroup -Name "SG-RESOURCE-Teams-GeneralChannel" -GroupScope Global -GroupCategory Security -Path "OU=ADSHMedical,DC=adshclass,DC=com" -Description "General Teams channel access"

# Add membership
Add-ADGroupMember -Identity "SG-RESOURCE-VPN-AllStaff"         -Members "SG-All-ADSHStaff"
Add-ADGroupMember -Identity "SG-RESOURCE-Teams-GeneralChannel" -Members "SG-All-ADSHStaff"


New-ADUser -Name "Emily Carter" -GivenName "Emily" -Surname "Carter" -SamAccountName "emily.carter" -UserPrincipalName "emily.carter@adshclass.com" -DisplayName "Emily Carter" -Title "HR Specialist" -Department "Administration" -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Noah James" -GivenName "Noah" -Surname "James" -SamAccountName "noah.james" -UserPrincipalName "noah.james@adshclass.com" -DisplayName "Noah James" -Title "Executive Assistant" -Department "Administration" -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Ava Mitchell" -GivenName "Ava" -Surname "Mitchell" -SamAccountName "ava.mitchell" -UserPrincipalName "ava.mitchell@adshclass.com" -DisplayName "Ava Mitchell" -Title "Office Manager" -Department "Administration" -Path "OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true


New-ADUser -Name "Dr. Liam Reynolds" -GivenName "Liam" -Surname "Reynolds" -SamAccountName "liam.reynolds" -UserPrincipalName "liam.reynolds@adshclass.com" -DisplayName "Dr. Liam Reynolds" -Title "Doctor" -Department "Clinical Services" -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Olivia Hayes" -GivenName "Olivia" -Surname "Hayes" -SamAccountName "olivia.hayes" -UserPrincipalName "olivia.hayes@adshclass.com" -DisplayName "Olivia Hayes" -Title "Nurse" -Department "Clinical Services" -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Ethan Brooks" -GivenName "Ethan" -Surname "Brooks" -SamAccountName "ethan.brooks" -UserPrincipalName "ethan.brooks@adshclass.com" -DisplayName "Ethan Brooks" -Title "Medical Assistant" -Department "Clinical Services" -Path "OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true

New-ADUser -Name "Sophia Bennett" -GivenName "Sophia" -Surname "Bennett" -SamAccountName "sophia.bennett" -UserPrincipalName "sophia.bennett@adshclass.com" -DisplayName "Sophia Bennett" -Title "Help Desk Technician" -Department "IT" -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Jackson Ford" -GivenName "Jackson" -Surname "Ford" -SamAccountName "jackson.ford" -UserPrincipalName "jackson.ford@adshclass.com" -DisplayName "Jackson Ford" -Title "Systems Administrator" -Department "IT" -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Isabella Chen" -GivenName "Isabella" -Surname "Chen" -SamAccountName "isabella.chen" -UserPrincipalName "isabella.chen@adshclass.com" -DisplayName "Isabella Chen" -Title "Security Analyst" -Department "IT" -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true


New-ADUser -Name "Lucas Morgan" -GivenName "Lucas" -Surname "Morgan" -SamAccountName "lucas.morgan" -UserPrincipalName "lucas.morgan@adshclass.com" -DisplayName "Lucas Morgan" -Title "Medical Coder" -Department "Billing & Records" -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Mia Rivera" -GivenName "Mia" -Surname "Rivera" -SamAccountName "mia.rivera" -UserPrincipalName "mia.rivera@adshclass.com" -DisplayName "Mia Rivera" -Title "Insurance Coordinator" -Department "Billing & Records" -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Benjamin Lee" -GivenName "Benjamin" -Surname "Lee" -SamAccountName "benjamin.lee" -UserPrincipalName "benjamin.lee@adshclass.com" -DisplayName "Benjamin Lee" -Title "Records Clerk" -Department "Billing & Records" -Path "OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true

New-ADUser -Name "Henry Wallace" -GivenName "Henry" -Surname "Wallace" -SamAccountName "henry.wallace" -UserPrincipalName "henry.wallace@adshclass.com" -DisplayName "Henry Wallace" -Title "Maintenance" -Department "Facilities & Support" -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Ella Simmons" -GivenName "Ella" -Surname "Simmons" -SamAccountName "ella.simmons" -UserPrincipalName "ella.simmons@adshclass.com" -DisplayName "Ella Simmons" -Title "Security Guard" -Department "Facilities & Support" -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "William Ortiz" -GivenName "William" -Surname "Ortiz" -SamAccountName "william.ortiz" -UserPrincipalName "william.ortiz@adshclass.com" -DisplayName "William Ortiz" -Title "Janitor" -Department "Facilities & Support" -Path "OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssword1" -AsPlainText -Force) -Enabled $true

Add-ADGroupMember -Identity "SG-HR_Specialist"       -Members emily.carter
Add-ADGroupMember -Identity "SG-Executive_Assistant" -Members noah.james
Add-ADGroupMember -Identity "SG-Office_Manager"      -Members ava.mitchell


Add-ADGroupMember -Identity "SG-Doctor"            -Members liam.reynolds
Add-ADGroupMember -Identity "SG-Nurse"             -Members olivia.hayes
Add-ADGroupMember -Identity "SG-Medical_Assistant" -Members ethan.brooks

Add-ADGroupMember -Identity "SG-Help_Desk"        -Members sophia.bennett
Add-ADGroupMember -Identity "SG-SysAdmin"         -Members jackson.ford
Add-ADGroupMember -Identity "SG-Security_Analyst" -Members isabella.chen

Add-ADGroupMember -Identity "SG-Medical_Coder"         -Members lucas.morgan
Add-ADGroupMember -Identity "SG-Insurance_Coordinator" -Members mia.rivera
Add-ADGroupMember -Identity "SG-Records_Clerk"         -Members benjamin.lee

Add-ADGroupMember -Identity "SG-Maintenance"     -Members henry.wallace
Add-ADGroupMember -Identity "SG-Security_Guard"  -Members ella.simmons
Add-ADGroupMember -Identity "SG-Janitor"         -Members william.ortiz

(Get-ADUser -Filter *).Count
(Get-ADGroup -Filter *).Count
(Get-ADComputer -Filter *).Count
(Get-ADOrganizationalUnit -Filter *).count
(Get-ADObject -Filter *).count
