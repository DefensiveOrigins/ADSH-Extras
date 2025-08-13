cd c:\ADSH
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/netwrix/pingcastle/releases/download/3.4.1.38/PingCastle_3.4.1.38.zip -OutFile PingCastle.zip
$ProgressPreference = 'Continue'
Expand-Archive .\PingCastle.zip
Remove-Item PingCastle.zip


cd c:\ADSH\PingCastle
./PingCastle.exe --server 127.0.0.1 --healthcheck --level Full --no-enum-limit

cd c:\ADSH\PingCastle
.\PingCastle.exe --scanner computerversion --scmode-all
.\PingCastle.exe --scanner laps_bitlocker --scmode-all
.\PingCastle.exe --scanner localadmin --scmode-all
.\PingCastle.exe --scanner nullsession --scmode-all
.\PingCastle.exe --scanner remote --scmode-all
# You may need to press enter here.
.\PingCastle.exe --scanner smb --scmode-all
.\PingCastle.exe --scanner spooler --scmode-all
.\PingCastle.exe --scanner startup --scmode-all
.\PingCastle.exe --scanner zerologon --scmode-all


New-Item -ItemType Directory -Path "C:\ADSH\PingCastleReports" -Force > $null
Move-Item -Path C:\ADSH\PingCastle\*ADSHClass.com* -Destination C:\ADSH\PingCastleReports\
cd c:\ADSH\PingCastleReports
Get-ChildItem | Select-Object Name, Length


cd c:\ADSH\PingCastleReports
.\ad_hc_adshclass.com.html
