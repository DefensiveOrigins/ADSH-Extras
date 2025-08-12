# Create a user account in the IT OU with no password configured
New-ADUser -Name "Test NoPassword" `
    -GivenName "Test" `
    -Surname "NoPassword" `
    -SamAccountName "test.nopassword" `
    -UserPrincipalName "test.nopassword@adshclass.com" `
    -DisplayName "Test NoPassword" `
    -Title "Test Account" `
    -Department "IT" `
    -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
    -Enabled $false


    # Create five users in IT OU with strong passwords, but password not required

$usersNoRequiredPassword = @(
    @{First="Alex"; Last="Fleming"; Password="Str0ngP@ssw0rd1!"},
    @{First="Brianna"; Last="Holt"; Password="Str0ngP@ssw0rd2!"},
    @{First="Carlos"; Last="Nguyen"; Password="Str0ngP@ssw0rd3!"},
    @{First="Diana"; Last="Patel"; Password="Str0ngP@ssw0rd4!"},
    @{First="Evan"; Last="Santos"; Password="Str0ngP@ssw0rd5!"}
)

foreach ($u in $usersNoRequiredPassword) {
    $sam = "$($u.First.ToLower()).$($u.Last.ToLower())"
    $upn = "$sam@adshclass.com"
    $display = "$($u.First) $($u.Last)"
    New-ADUser -Name $display `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $sam `
        -UserPrincipalName $upn `
        -DisplayName $display `
        -Title "IT Test User" `
        -Department "IT" `
        -Path "OU=IT,OU=ADSHMedical,DC=adshclass,DC=com" `
        -AccountPassword (ConvertTo-SecureString $u.Password -AsPlainText -Force) `
        -PasswordNotRequired $true `
        -Enabled $true
}
