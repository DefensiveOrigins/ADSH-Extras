New-Item -ItemType Directory -Path "C:\ADSH\GPO-reports" -Force > $null 
cd C:\ADSH\GPO-reports

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force 
Install-Module -Name GPOZaurr -AllowClobber -Force

Invoke-GPOZaurr -FilePath "C:\ADSH\GPO-reports\GPOZaurr-Report.html"
