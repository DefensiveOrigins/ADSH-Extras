 python -V
 python -m pip install --upgrade pip


 New-Item -ItemType Directory -Path "C:\ADSH\PlumHound" -Force > $null 
cd C:\ADSH\PlumHound
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest https://github.com/PlumHound/PlumHound/archive/refs/heads/master.zip -OutFile PlumHound.zip
$ProgressPreference = 'Continue'
Expand-Archive PlumHound.zip
ls .\PlumHound\PlumHound-master\| Select-Object Name, Length

 cd C:\ADSH\PlumHound\PlumHound\PlumHound-master\
 pip install -r .\requirements.txt

 python PlumHound.py -s "bolt://localhost:7687" -u neo4j -p 'neo4jneo4j' -x tasks/default.tasks

  New-Item -ItemType Directory -Path "C:\ADSH\PlumHound-Reports" -Force > $null 
 mv C:\ADSH\PlumHound\PlumHound\PlumHound-master\reports\*   C:\ADSH\PlumHound-Reports\
 ls C:\ADSH\PlumHound-Reports\ | Select-Object Name, Length

 cd c:\ADSH\PlumHound-Reports\
./index.html