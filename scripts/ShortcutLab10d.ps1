 Write-Output "[*] Setup Python Pip" 
 python -V
 python -m pip install --upgrade pip

 Write-Output "[*] Get PlumHound" 
 New-Item -ItemType Directory -Path "C:\ADSH\PlumHound" -Force > $null 
cd C:\ADSH\PlumHound
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/PlumHound/PlumHound/archive/refs/heads/master.zip -OutFile PlumHound.zip
$ProgressPreference = 'Continue'
Expand-Archive PlumHound.zip
ls .\PlumHound\PlumHound-master\| Select-Object Name, Length

Write-Output "[*] Setup PlumHound" 
 cd C:\ADSH\PlumHound\PlumHound\PlumHound-master\
 pip install -r .\requirements.txt

 Write-Output "[*] Run PlumHound" 

 python PlumHound.py -s "bolt://localhost:7687" -u neo4j -p 'neo4jneo4j' -x tasks/default.tasks

  New-Item -ItemType Directory -Path "C:\ADSH\PlumHound-Reports" -Force > $null 
 mv C:\ADSH\PlumHound\PlumHound\PlumHound-master\reports\*   C:\ADSH\PlumHound-Reports\
 ls C:\ADSH\PlumHound-Reports\ | Select-Object Name, Length

 Write-Output "[*] Open Reports " 

 cd c:\ADSH\PlumHound-Reports\
./index.html

Write-Output "[!] Done" 