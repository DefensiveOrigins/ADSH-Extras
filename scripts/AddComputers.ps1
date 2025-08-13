# Create 20 computer accounts in each department OU using New-ADComputer

$departments = @(
    @{Abbr="ADM"; OU="OU=Administration,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Abbr="CLN"; OU="OU=ClinicalServices,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Abbr="IT";  OU="OU=IT,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Abbr="BIL"; OU="OU=BillingAndRecords,OU=ADSHMedical,DC=adshclass,DC=com"},
    @{Abbr="FAC"; OU="OU=FacilitiesAndSupport,OU=ADSHMedical,DC=adshclass,DC=com"}
)

foreach ($dept in $departments) {
    for ($i=1; $i -le 20; $i++) {
        Write-Progress -Activity "Creating Computers for $($dept.OU)" -Status "$i of 20" -PercentComplete ($i*5)
        $pcName = "$($dept.Abbr)-PC{0:D2}" -f $i
        New-ADComputer -Name $pcName `
            -SamAccountName $pcName `
            -Path $dept.OU `
            -Enabled $true
    }
}

# Create 5 IT department computers trusted for delegation (not domain controllers)

$itOU = "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com"

for ($i=1; $i -le 5; $i++) {
    Write-Progress -Activity "Creating Trusted Delegation Computers" -Status "$i of 5" -PercentComplete ($i*20)
    $compName = "IT-DEL-PC0$i"
    New-ADComputer -Name $compName `
        -SamAccountName $compName `
        -Path $itOU `
        -Enabled $true
    # Set trusted for delegation (Kerberos only)
    Set-ADComputer -Identity $compName -TrustedForDelegation $true
}
