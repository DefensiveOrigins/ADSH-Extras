Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')



# Use a 3.5.1 build for old BloodHound; 3.5.30 is commonly available
choco install neo4j-community --version=3.5.10 -y --accept-license


# Install the service using the Chocolatey shim
& "$env:ProgramData\chocolatey\bin\neo4j.bat" install-service

# Find the service name and set to Automatic + start
$svc = Get-Service -Name 'neo4j' -ErrorAction SilentlyContinue
if (-not $svc) { $svc = Get-Service -Name 'neo4j-community' -ErrorAction SilentlyContinue }
Set-Service -Name $svc.Name -StartupType Automatic
Start-Service -Name $svc.Name
