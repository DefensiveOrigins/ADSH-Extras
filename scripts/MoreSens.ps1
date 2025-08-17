# ===== Vars =====
$ShareRoot = 'C:\ADSH\PIIShare'        # must match your classification rule's -Namespace
$Samples   = Join-Path $ShareRoot 'Samples'

# ===== Helpers =====
function New-FakeSsn {
    param([switch]$Hyphen, [switch]$Spaced)
    # Generate a "valid-ish" SSN: area != 000/666, group != 00, serial != 0000
    $area  = Get-Random -Minimum 1   -Maximum 773
    while ($area -eq 666 -or $area -eq 0) { $area = Get-Random -Minimum 1 -Maximum 773 }
    $group = Get-Random -Minimum 1   -Maximum 100
    $serial= Get-Random -Minimum 1   -Maximum 10000
    $a = ('{0:000}' -f $area)
    $g = ('{0:00}'  -f $group)
    $s = ('{0:0000}'-f $serial)
    if ($Hyphen) { return "$a-$g-$s" }
    elseif ($Spaced) { return "$a $g $s" }
    else { return "$a$g$s" }
}

function Ensure-Dir { param($Path) if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Path $Path -Force | Out-Null } }

# ===== Create sample tree =====
Ensure-Dir $ShareRoot
Ensure-Dir $Samples
$dirs = @(
  'HR','Finance','Dev','Configs','Logs','DB','Backups'
) | ForEach-Object { $p = Join-Path $Samples $_; Ensure-Dir $p; $p }

# ----- Create SSN-rich files (various formats & names Snaffler likes) -----

# HR – CSV w/ hyphenated SSNs
$hrCsv = Join-Path $Samples 'HR\Employees-PII.csv'
$rows = @("Name,Dept,SSN")
1..12 | ForEach-Object {
  $name = "Emp$($_)"
  $dept = (Get-Random @('HR','IT','Finance','Ops','Sales'))
  $ssn  = New-FakeSsn -Hyphen
  $rows += "$name,$dept,$ssn"
}
$rows | Set-Content -Path $hrCsv -Encoding UTF8

# HR – text with mixed formats and obvious keywords
$hrTxt = Join-Path $Samples 'HR\Benefits-SSN-List.txt'
@(
  "CONFIDENTIAL HR ONLY",
  "Jane Doe SSN: $(New-FakeSsn -Hyphen)",
  "John Smith SSN $(New-FakeSsn -Spaced)",
  "Recruit temp: $(New-FakeSsn)",                               # contiguous digits
  "Legacy record (W-2): SSN=$(New-FakeSsn -Hyphen)"
) | Set-Content $hrTxt -Encoding UTF8

# Finance – payroll export (no hyphens)
$finCsv = Join-Path $Samples 'Finance\Payroll_2025_Q3.csv'
@(
  "EmployeeID,Pay,TaxID",
  "1001,92000,$(New-FakeSsn)",
  "1002,87500,$(New-FakeSsn)",
  "1003,101500,$(New-FakeSsn)"
) | Set-Content $finCsv -Encoding UTF8

# Dev – .env w/ secrets and an inline SSN
$envFile = Join-Path $Samples 'Dev\.env'
@(
  "# demo, do not commit",
  "API_TOKEN=demo-$(Get-Random -Maximum 999999999)",
  "SSN=$(New-FakeSsn -Hyphen)"
) | Set-Content $envFile -Encoding UTF8

# Dev – JSON w/ nested SSN
$appJson = Join-Path $Samples 'Dev\appsettings.json'
@"
{
  "Logging": { "Level": "Warning" },
  "TestUser": { "Name": "Casey", "SSN": "$(New-FakeSsn -Spaced)" }
}
"@ | Set-Content $appJson -Encoding UTF8

# Configs – XML w/ SSN element
$xmlFile = Join-Path $Samples 'Configs\hr.config'
@"
<settings>
  <owner>HR</owner>
  <ssn>$(New-FakeSsn -Hyphen)</ssn>
</settings>
"@ | Set-Content $xmlFile -Encoding UTF8

# Logs – app log w/ accidental SSN
$logFile = Join-Path $Samples 'Logs\app.log'
@(
  "$(Get-Date -Format s) INFO Auth success user=jsmith",
  "$(Get-Date -Format s) WARN user profile contained SSN $(New-FakeSsn)"
) | Set-Content $logFile -Encoding UTF8

# DB – SQL dump w/ SSNs
$sqlFile = Join-Path $Samples 'DB\employees.sql'
@"
CREATE TABLE employees (id INT, name NVARCHAR(100), ssn NVARCHAR(11));
INSERT INTO employees VALUES (1,'Pat Green','$(New-FakeSsn -Hyphen)');
INSERT INTO employees VALUES (2,'R. Brown','$(New-FakeSsn -Spaced)');
INSERT INTO employees VALUES (3,'T. White','$(New-FakeSsn)');
"@ | Set-Content $sqlFile -Encoding UTF8

# Dev – script file with SSN in a comment (Snaffler content+name hit)
$ps1File = Join-Path $Samples 'Dev\Export-HR.ps1'
@"
# TODO: redact SSN before export -> $(New-FakeSsn -Hyphen)
param([string]\$Path)
'export done' | Out-File \$Path
"@ | Set-Content $ps1File -Encoding UTF8

# Backups – a ZIP that includes PII (FSRM usually won't scan inside; Snaffler will notice the name)
$inner = Join-Path $Samples 'Backups\PII'
Ensure-Dir $inner
Set-Content -Path (Join-Path $inner 'raw-hr-data.txt') -Value "SSN $(New-FakeSsn -Hyphen)" -Encoding UTF8
$zipPath = Join-Path $Samples 'Backups\PII-Archive.zip'
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path (Join-Path $inner '*') -DestinationPath $zipPath
