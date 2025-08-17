New-Item -ItemType Directory -Path "C:\ADSH\Badblood" -Force > $null
cd C:\ADSH\Badblood
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -URI https://github.com/Relkci/BadBlood/archive/refs/heads/master.zip -OutFile BadBlood.zip
$ProgressPreference = 'Continue'
tar -xf .\BadBlood.zip
Remove-Item .\BadBlood.zip
ls C:\ADSH\Badblood\BadBlood-master\ | Select-Object Name, Length

cd C:\ADSH\Badblood\BadBlood-master\
Set-ExecutionPolicy bypass -force
.\Invoke-BadBlood.ps1 50 50 50  $true $true $true


(Get-ADUser -Filter *).Count
(Get-ADGroup -Filter *).Count
(Get-ADComputer -Filter *).Count
(Get-ADOrganizationalUnit -Filter *).count
(Get-ADObject -Filter *).count
