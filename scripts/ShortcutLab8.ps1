Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH\GPO-reports" -Force > $null 
cd C:\ADSH\GPO-reports

Write-Output "[*] Install GPZaurr" 

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force 
Install-Module -Name GPOZaurr -AllowClobber -Force

Write-Output "[*] Invoke" 

Invoke-GPOZaurr -FilePath "C:\ADSH\GPO-reports\GPOZaurr-Report.html"


Write-Output "[!] Done" 

