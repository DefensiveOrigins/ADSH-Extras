Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH\GroupReport" -Force > $null 
cd C:\ADSH\GroupReport

Write-Output "[*] Get DotNet" 
$ProgressPreference = 'SilentlyContinue' 
Invoke-WebRequest https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-win-x64.exe -OutFile dotnet-runtime-8.0.19-win-x64.exe
$ProgressPreference = 'Continue' 
.\dotnet-runtime-8.0.19-win-x64.exe /install /quiet /norestart

Write-Output "[*] Get ADGroupDiagram" 

cd C:\ADSH\GroupReport
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/DefensiveOrigins/ADGroupDiagram/raw/refs/heads/main/App/ADGroupDiagram.exe -OutFile ADGroupDiagram.exe

 Write-Output "[*] Create Report 1"
 
.\ADGroupDiagram.exe 
 mv .\ad-groups.html .\ad-groups-only.html
 $ProgressPreference = 'Continue' 
 Get-ChildItem | Select-Object Name, Length
 
 Write-Output "[*] Create Report 2" 

cd C:\ADSH\GroupReport
.\ADGroupDiagram.exe -u
 mv .\ad-groups.html .\ad-groups-with-users.html
 Get-ChildItem | Select-Object Name, Length

  Write-Output "[*] Open Reports" 
cd C:\ADSH\GroupReport
 ./ad-groups-only.html
 ./ad-groups-with-users.html

   Write-Output "[!] Done" 