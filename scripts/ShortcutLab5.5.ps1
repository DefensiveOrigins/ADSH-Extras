Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH\Badblood" -Force > $null
cd C:\ADSH\Badblood
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -URI https://github.com/Relkci/BadBlood/archive/refs/heads/master.zip -OutFile BadBlood.zip
$ProgressPreference = 'Continue'
tar -xf .\BadBlood.zip
Remove-Item .\BadBlood.zip
ls C:\ADSH\Badblood\BadBlood-master\ | Select-Object Name, Length

Write-Output "[*] Run Badblood" 
cd C:\ADSH\Badblood\BadBlood-master\
Set-ExecutionPolicy bypass -force
.\Invoke-BadBlood.ps1 50 50 50  $true $true $true


Write-Output "[*] Users:"
(Get-ADUser -Filter *).Count
Write-Output "[*] Groups:"
(Get-ADGroup -Filter *).Count
Write-Output "[*] Computers:"
(Get-ADComputer -Filter *).Count
Write-Output "[*] OUs:"
(Get-ADOrganizationalUnit -Filter *).count
Write-Output "[*] Objects:"
(Get-ADObject -Filter *).count

Write-Output "[!] Done"

