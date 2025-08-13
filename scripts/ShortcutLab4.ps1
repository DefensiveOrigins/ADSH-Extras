New-Item -ItemType Directory -Path "C:\ADSH\AD-reports" -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Testimo -AllowClobber -Force -SkipPublisherCheck
Install-Module -Name "PSWriteColor" -Force -SkipPublisherCheck
cd c:\ADSH\AD-reports
Invoke-Testimo -FilePath c:\ADSH\AD-reports\Testimo-Report.html
