Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH\AD-reports" -Force
iex ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/Set-EdgeFRU.ps1"))
Write-Output "[*] Install Modules" 
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Testimo -AllowClobber -Force -SkipPublisherCheck
Install-Module -Name "PSWriteColor" -Force -SkipPublisherCheck
cd c:\ADSH\AD-reports
Write-Output "[*] Run Testimo Modules" 
Invoke-Testimo -FilePath c:\ADSH\AD-reports\Testimo-Report.html


Write-Output "[!] Done"