cd c:\ADSH
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -URI https://download.sysinternals.com/files/AdExplorer.zip -OutFile ADExplorer.zip
$ProgressPreference = 'Continue'
Expand-Archive ADExplorer.zip
Remove-Item ADExplorer.zip
New-Item -ItemType Directory -Path "C:\ADSH\ADExplorer-Snapshots" -Force > $null
Get-ChildItem  C:\ADSH\ADExplorer\ | Select-Object Name, Length

cd c:\ADSH\AdExplorer 
./AdExplorer64.exe -snapshot "ADSHclass.com" c:\ADSH\ADExplorer-Snapshots\ADSHClass.com.1.dat  -accepteula 
Start-Sleep -Seconds 2
Get-ChildItem  C:\ADSH\ADExplorer-Snapshots\ | Select-Object Name, Length

cd c:\ADSH
DSADD user -upn Jolly.Rogers@ADSHclass.com "cn=Jolly.Rogers,CN=Users,DC=ADSHClass,DC=com" -fn "Jolly" -ln "Rogers" -disabled no -display "Jolly Rogers" -desc "Ranch Manager" -office "Yellowstone" -title "Ranch Manager" -company "Branch Ranch" -PWD "Badpass215613!!3"
Set-ADUser -Identity Jolly.Rogers -PasswordNeverExpires $true
Start-Sleep -Seconds 5
cd c:\ADSH\AdExplorer 
./AdExplorer64.exe -snapshot "ADSHclass.com" c:\ADSH\ADExplorer-Snapshots\ADSHClass.com.2.dat  -accepteula
Start-Sleep -Seconds 2
Get-ChildItem  C:\ADSH\ADExplorer-Snapshots\ | Select-Object Name, Length



cd C:\ADSH\ADExplorer-Snapshots\
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/DefensiveOrigins/adexplorersnapshot-rs/releases/download/v0.0.2/convertsnapshot.exe -OutFile convertsnapshot.exe
Invoke-WebRequest https://github.com/DefensiveOrigins/ADExplorerSnapshotRSComparer/raw/refs/heads/main/bin/Release/net8.0/publish/win-x86/AdExpDiffTar.exe -OutFile AdExpDiffTar.exe
$ProgressPreference = 'Continue'
Get-ChildItem  C:\ADSH\ADExplorer-Snapshots\ | Select-Object Name, Length


cd C:\ADSH\ADExplorer-Snapshots\
.\convertsnapshot.exe -o ADSHClass.com.1.tar.gz .\ADSHClass.com.1.dat
.\convertsnapshot.exe -o ADSHClass.com.2.tar.gz .\ADSHClass.com.2.dat
Get-ChildItem  C:\ADSH\ADExplorer-Snapshots\ | Select-Object Name, Length

cd C:\ADSH\ADExplorer-Snapshots\
.\AdExpDiffTar.exe --oldtgz ADSHClass.com.1.tar.gz --newtgz  ADSHClass.com.2.tar.gz --output ad_compare.html
Get-ChildItem  C:\ADSH\ADExplorer-Snapshots\ | Select-Object Name, Length

cd C:\ADSH\ADExplorer-Snapshots\
./ad_compare.html

cd c:\ADSH\AdExplorer
./AdExplorer64.exe /accepteula

