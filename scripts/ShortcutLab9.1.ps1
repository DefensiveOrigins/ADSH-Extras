cd c:\ADSH
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -URI https://download.sysinternals.com/files/AdExplorer.zip -OutFile ADExplorer.zip
$ProgressPreference = 'Continue'
Expand-Archive ADExplorer.zip
Remove-Item ADExplorer.zip
New-Item -ItemType Directory -Path "C:\ADSH\ADExplorer-Snapshots" -Force > $null
ls ADExplorer

cd c:\ADSH\AdExplorer 
./AdExplorer64.exe -snapshot "ADSHclass.com" c:\ADSH\ADExplorer-Snapshots\ADSHClass.com.1.dat  -accepteula 
ls C:\ADSH\ADExplorer-Snapshots\

cd c:\ADSH
DSADD user -upn Jolly.Rogers@ADSHclass.com "cn=Jolly.Rogers,CN=Users,DC=ADSHClass,DC=com" -fn "Jolly" -ln "Rogers" -disabled no -display "Jolly Rogers" -desc "Ranch Manager" -office "Yellowstone" -title "Ranch Manager" -company "Branch Ranch" -PWD "Badpass215613!!3"
Set-ADUser -Identity Jolly.Rogers -PasswordNeverExpires $true

cd c:\ADSH\AdExplorer 
./AdExplorer64.exe -snapshot "ADSHclass.com" c:\ADSH\ADExplorer-Snapshots\ADSHClass.com.2.dat  -accepteula
ls C:\ADSH\ADExplorer-Snapshots\

cd c:\ADSH\AdExplorer
./AdExplorer64.exe /accepteula
