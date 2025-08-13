New-Item -ItemType Directory -Path "C:\ADSH\GroupReport" -Force > $null 
cd C:\ADSH\GroupReport
IEX(New-Object Net.Webclient).DownloadString('https://https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-win-x64.exe')
.\dotnet-runtime-8.0.19-win-x64.exe /install /quiet /norestart

cd C:\ADSH\GroupReport
Invoke-WebRequest https://github.com/DefensiveOrigins/ADGroupDiagram/raw/refs/heads/main/App/ADGroupDiagram.exe -OutFile ADGroupDiagram.exe
.\ADGroupDiagram.exe 
 mv .\ad-groups.html .\ad-groups-only.html
 Get-ChildItem | Select-Object Name, Length

 cd C:\ADSH\GroupReport
.\ADGroupDiagram.exe -u
 mv .\ad-groups.html .\ad-groups-with-users.html
 Get-ChildItem | Select-Object Name, Length

cd C:\ADSH\GroupReport
.\ad-groups-only.html
.\ad-groups-with-users.html
