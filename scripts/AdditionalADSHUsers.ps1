# Static lists for deterministic user creation
$firstNames = @(
    "Emily","Noah","Ava","Liam","Olivia","Ethan","Sophia","Jackson","Isabella","Lucas",
    "Mia","Benjamin","Henry","Ella","William","Grace","James","Charlotte","Michael","Amelia",
    "Alexander","Harper","Daniel","Abigail","Matthew","David","Joseph","Victoria","Samuel","Penelope",
    "Andrew","Layla","Joshua","Aria","Christopher","Chloe","Ryan","Zoey","Nathan","Nora",
    "Jonathan","Lily","Christian","Hannah","Gabriel","Avery","Anthony","Eleanor","Isaac","Addison",
    "Madison","Elijah","Elizabeth","Sebastian","Brooklyn","Jack","Scarlett","Julian","Zoey","Levi",
    "Stella","Aaron","Hazel","Wyatt","Paisley","Owen","Aurora","Dylan","Savannah","Caleb",
    "Bella","Luke","Camila","Mason","Aubrey","Jayden","Lucy","Carter","Anna","Hunter",
    "Samantha","Connor","Kennedy","Isaiah","Sadie","Lincoln","Skylar","Hudson","Genesis","Jaxon"
)
$lastNames = @(
    "Carter","James","Mitchell","Reynolds","Hayes","Brooks","Bennett","Ford","Chen","Morgan",
    "Rivera","Lee","Wallace","Simmons","Ortiz","Clark","Turner","Parker","Evans","Cooper",
    "Morris","Murphy","Cook","Rogers","Peterson","Bailey","Kelly","Howard","Ward","Cox",
    "Diaz","Richardson","Wood","Watson","Gray","Hughes","Foster","Sanders","Ross","Henderson",
    "Coleman","Jenkins","Perry","Powell","Long","Patterson","Russell","Alexander","Butler","Barnes",
    "Gonzalez","Bryant","Nelson","Cruz","Reed","Price","Bell","Stewart","Sanchez","Morris",
    "Rogers","Cook","Morgan","Peterson","Bailey","Kelly","Howard","Ward","Cox","Diaz",
    "Richardson","Wood","Watson","Brooks","Gray","Bennett","James","Hughes","Foster","Sanders"
)

# Job functions and OUs (cycled through for 100 users)
$jobFunctions = @(
    @{Title="HR Specialist";OU="Administration";Group="SG-HR_Specialist"},
    @{Title="Executive Assistant";OU="Administration";Group="SG-Executive_Assistant"},
    @{Title="Office Manager";OU="Administration";Group="SG-Office_Manager"},
    @{Title="Doctor";OU="ClinicalServices";Group="SG-Doctor"},
    @{Title="Nurse";OU="ClinicalServices";Group="SG-Nurse"},
    @{Title="Medical Assistant";OU="ClinicalServices";Group="SG-Medical_Assistant"},
    @{Title="Help Desk Technician";OU="IT";Group="SG-Help_Desk"},
    @{Title="Systems Administrator";OU="IT";Group="SG-SysAdmin"},
    @{Title="Security Analyst";OU="IT";Group="SG-Security_Analyst"},
    @{Title="Medical Coder";OU="BillingAndRecords";Group="SG-Medical_Coder"},
    @{Title="Insurance Coordinator";OU="BillingAndRecords";Group="SG-Insurance_Coordinator"},
    @{Title="Records Clerk";OU="BillingAndRecords";Group="SG-Records_Clerk"},
    @{Title="Maintenance Staff";OU="FacilitiesAndSupport";Group="SG-Maintenance"},
    @{Title="Security Guard";OU="FacilitiesAndSupport";Group="SG-Security_Guard"},
    @{Title="Janitorial Staff";OU="FacilitiesAndSupport";Group="SG-Janitor"}
)

# Static password list (repeatable, not random)
$passwords = @(
    "P@ssw0rd01!","P@ssw0rd02!","P@ssw0rd03!","P@ssw0rd04!","P@ssw0rd05!","P@ssw0rd06!","P@ssw0rd07!","P@ssw0rd08!","P@ssw0rd09!","P@ssw0rd10!",
    "P@ssw0rd11!","P@ssw0rd12!","P@ssw0rd13!","P@ssw0rd14!","P@ssw0rd15!","P@ssw0rd16!","P@ssw0rd17!","P@ssw0rd18!","P@ssw0rd19!","P@ssw0rd20!",
    "P@ssw0rd21!","P@ssw0rd22!","P@ssw0rd23!","P@ssw0rd24!","P@ssw0rd25!","P@ssw0rd26!","P@ssw0rd27!","P@ssw0rd28!","P@ssw0rd29!","P@ssw0rd30!",
    "P@ssw0rd31!","P@ssw0rd32!","P@ssw0rd33!","P@ssw0rd34!","P@ssw0rd35!","P@ssw0rd36!","P@ssw0rd37!","P@ssw0rd38!","P@ssw0rd39!","P@ssw0rd40!",
    "P@ssw0rd41!","P@ssw0rd42!","P@ssw0rd43!","P@ssw0rd44!","P@ssw0rd45!","P@ssw0rd46!","P@ssw0rd47!","P@ssw0rd48!","P@ssw0rd49!","P@ssw0rd50!",
    "P@ssw0rd51!","P@ssw0rd52!","P@ssw0rd53!","P@ssw0rd54!","P@ssw0rd55!","P@ssw0rd56!","P@ssw0rd57!","P@ssw0rd58!","P@ssw0rd59!","P@ssw0rd60!",
    "P@ssw0rd61!","P@ssw0rd62!","P@ssw0rd63!","P@ssw0rd64!","P@ssw0rd65!","P@ssw0rd66!","P@ssw0rd67!","P@ssw0rd68!","P@ssw0rd69!","P@ssw0rd70!",
    "P@ssw0rd71!","P@ssw0rd72!","P@ssw0rd73!","P@ssw0rd74!","P@ssw0rd75!","P@ssw0rd76!","P@ssw0rd77!","P@ssw0rd78!","P@ssw0rd79!","P@ssw0rd80!",
    "P@ssw0rd81!","P@ssw0rd82!","P@ssw0rd83!","P@ssw0rd84!","P@ssw0rd85!","P@ssw0rd86!","P@ssw0rd87!","P@ssw0rd88!","P@ssw0rd89!","P@ssw0rd90!",
    "P@ssw0rd91!","P@ssw0rd92!","P@ssw0rd93!","P@ssw0rd94!","P@ssw0rd95!","P@ssw0rd96!","P@ssw0rd97!","P@ssw0rd98!","P@ssw0rd99!","P@ssw0rd100!"
)
# Create 100 static users
for ($i=0; $i -lt 100; $i++) {
    $first = $firstNames[$i % $firstNames.Count]
    $last = $lastNames[$i % $lastNames.Count]
    $job = $jobFunctions[$i % $jobFunctions.Count]
    $sam = "$($first.ToLower()).$($last.ToLower())$($i+1)"
    $upn = "$sam@adshclass.com"
    $display = "$first $last"
    $pw = $passwords[$i]
    $ouPath = "OU=$($job.OU),OU=ADSHMedical,DC=adshclass,DC=com"
    $title = $job.Title
    $dept = $job.OU -replace "([A-Z])", " $1" -replace "^ ", ""
    New-ADUser -Name $display `
        -GivenName $first `
        -Surname $last `
        -SamAccountName $sam `
        -UserPrincipalName $upn `
        -DisplayName $display `
        -Title $title `
        -Department $dept `
        -Path $ouPath `
        -AccountPassword (ConvertTo-SecureString $pw -AsPlainText -Force) `
        -Enabled $true
    # Add to job function group
    Add-ADGroupMember -Identity $job.Group -Members $sam
}
# --- High Privileged Service Account ---
$svcSam = "svc_ADSHAdmin"
$svcPw = "S3rv1c3P@ss!"
New-ADUser -Name "ADSH Service Account" `
    -SamAccountName $svcSam `
    -UserPrincipalName "$svcSam@adshclass.com" `
    -DisplayName "ADSH Service Account" `
    -Title "Domain Service Account" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString $svcPw -AsPlainText -Force) `
    -Enabled $true
# Create high privilege group and add service account
New-ADGroup -Name "SG-Privileged-Admins" -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "High privilege admin group"
Add-ADGroupMember -Identity "SG-Privileged-Admins" -Members $svcSam
# --- Helpdesk Group ---
New-ADGroup -Name "SG-Helpdesk" -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Helpdesk support group"
# Add all Help Desk Technicians to Helpdesk group
$helpdeskUsers = Get-ADUser -Filter {Title -eq "Help Desk Technician"} -SearchBase "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com"
foreach ($user in $helpdeskUsers) {
    Add-ADGroupMember -Identity "SG-Helpdesk" -Members $user.SamAccountName
}
# --- Password Managers Group ---
New-ADGroup -Name "SG-PasswordManagers" -GroupScope Global -GroupCategory Security -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" -Description "Group with privilege to reset all passwords"
# Create a user who is NOT in Helpdesk, and add to PasswordManagers
$pwMgrFirst = "Morgan"
$pwMgrLast = "Bishop"
$pwMgrSam = "morgan.bishop_pw"
$pwMgrUpn = "$pwMgrSam@adshclass.com"
$pwMgrPw = "P@ssw0rdPM!"
New-ADUser -Name "$pwMgrFirst $pwMgrLast" `
    -GivenName $pwMgrFirst `
    -Surname $pwMgrLast `
    -SamAccountName $pwMgrSam `
    -UserPrincipalName $pwMgrUpn `
    -DisplayName "$pwMgrFirst $pwMgrLast" `
    -Title "Password Manager" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -AccountPassword (ConvertTo-SecureString $pwMgrPw -AsPlainText -Force) `
    -Enabled $true
Add-ADGroupMember -Identity "SG-PasswordManagers" -Members $pwMgrSam

# (Control path violation: pwMgrSam is not in Helpdesk, but can reset passwords for all users)
