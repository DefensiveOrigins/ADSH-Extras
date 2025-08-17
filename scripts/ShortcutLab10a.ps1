Set-ExecutionPolicy Bypass -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')

choco install neo4j-community --version=3.5.1 -y --accept-license


start-process "http://localhost:7474/browser/"
