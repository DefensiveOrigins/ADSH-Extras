# Create 100 computer accounts, evenly distributed across department OUs

$departments = @(
    @{Name="Administration"; Abbr="ADM"; OU="OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Name="ClinicalServices"; Abbr="CLN"; OU="OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Name="IT"; Abbr="IT"; OU="OU=IT,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Name="BillingAndRecords"; Abbr="BIL"; OU="OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Name="FacilitiesAndSupport"; Abbr="FAC"; OU="OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com"}
)

for ($i=1; $i -le 100; $i++) {
    $deptIndex = ($i - 1) % $departments.Count
    $dept = $departments[$deptIndex]
    $pcNum = "{0:D3}" -f [math]::Ceiling($i / $departments.Count + $deptIndex * 20)
    $compName = "$($dept.Abbr)-PC$pcNum"
    New-ADComputer -Name $compName `
        -SamAccountName $compName `
        -Path $dept.OU `
        -Enabled $true
}


# Create 5 IT department computers trusted for delegation (not domain controllers)

$itOU = "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com"

for ($i=1; $i -le 5; $i++) {
    $compName = "IT-DEL-PC0$i"
    New-ADComputer -Name $compName `
        -SamAccountName $compName `
        -Path $itOU `
        -Enabled $true
    # Set trusted for delegation (Kerberos only)
    Set-ADComputer -Identity $compName -TrustedForDelegation $true
}
