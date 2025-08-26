Write-Output "[*] Setup" 
Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Write-Output "[*] Install Chocolatey" 
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')
Write-Output "[*] Install Neo5j" 
choco install neo4j-community --version=3.5.1 -y --accept-license


start-process "http://localhost:7474/browser/"

Write-Output "[!] Continue]" 
