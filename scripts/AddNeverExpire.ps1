# Create 10 users with passwords that never expire, assigned to job function groups

$neverExpireUsers = @(
    @{First="Paula"; Last="Morris"; Title="HR Specialist"; Dept="Administration"; Group="SG-HR_Specialist"; Password="NeverExp01!"},
    @{First="Victor"; Last="Cook"; Title="Executive Assistant"; Dept="Administration"; Group="SG-Executive_Assistant"; Password="NeverExp02!"},
    @{First="Sandra"; Last="Rogers"; Title="Office Manager"; Dept="Administration"; Group="SG-Office_Manager"; Password="NeverExp03!"},
    @{First="Greg"; Last="Peterson"; Title="Doctor"; Dept="ClinicalServices"; Group="SG-Doctor"; Password="NeverExp04!"},
    @{First="Tina"; Last="Bailey"; Title="Nurse"; Dept="ClinicalServices"; Group="SG-Nurse"; Password="NeverExp05!"},
    @{First="Derek"; Last="Kelly"; Title="Medical Assistant"; Dept="ClinicalServices"; Group="SG-Medical_Assistant"; Password="NeverExp06!"},
    @{First="Monica"; Last="Howard"; Title="Help Desk Technician"; Dept="IT"; Group="SG-Help_Desk"; Password="NeverExp07!"},
    @{First="Ethan"; Last="Ward"; Title="Systems Administrator"; Dept="IT"; Group="SG-SysAdmin"; Password="NeverExp08!"},
    @{First="Jasmine"; Last="Cox"; Title="Medical Coder"; Dept="BillingAndRecords"; Group="SG-Medical_Coder"; Password="NeverExp09!"},
    @{First="Kyle"; Last="Diaz"; Title="Maintenance Staff"; Dept="FacilitiesAndSupport"; Group="SG-Maintenance"; Password="NeverExp10!"}
)

$counter = 0
$total = $neverExpireUsers.Count

foreach ($u in $neverExpireUsers) {
    $counter++
    Write-Progress -Activity "Never Expire Users" -Status "$counter of $total" -PercentComplete ($counter / $total  * 100)
    $sam = "$($u.First.ToLower()).$($u.Last.ToLower())"
    $upn = "$sam@adshclass.com"
    $display = "$($u.First) $($u.Last)"
    $ouPath = "OU=$($u.Dept),OU=ADSHMedical,DC=adshclass,DC=com"
    New-ADUser -Name $display `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $sam `
        -UserPrincipalName $upn `
        -DisplayName $display `
        -Title $u.Title `
        -Department $u.Dept `
        -Path $ouPath `
        -AccountPassword (ConvertTo-SecureString $u.Password -AsPlainText -Force) `
        -PasswordNeverExpires $true `
        -Enabled $true
    Add-ADGroupMember -Identity $u.Group -Members $sam
}
