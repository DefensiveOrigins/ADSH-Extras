Write-Output "[*] Setup" 
New-Item -ItemType Directory -Path "C:\ADSH\" -Force > $null
New-Item -ItemType Directory -Path "C:\ADSH\NetworkEgress\" -Force > $null

cd C:\ADSH\NetworkEgress\
Write-Output "[*] Test Egress" 
$target = ( resolve-dnsname -Type A bhis.tech ).IPAddress
echo 80,23,443,21,22,25,3389,110,445,139,143,53,135,3306,8080,1723,111,995,993,5900,1025,587,8888,199,1720,465,548,113,81,6001,10000,514,5060,179,1026,2000,8443,8000,32768,554,26,1433,49152,2001,515,8008,49154,1027,5666,646,5000,5631,631,49153,8081,2049,88,79,5800,106,2121,1110,49155,6000,513,990,5357,427,49156,543,544,5101,144,7,389,8009,3128,444,9999,5009,7070,5190,3000,5432,1900,3986,13,1029,9,6646,5051,49157,1028,873,1755,2717,4899,9100,119,37,1000,3001,5001,82,10010,1030,9090,2107,1024,2103,6004,1801,5050,19,8031,1041,255,1056,1049,1065,2967,1053,1048,1064,1054,3703,17,808 | foreach-object { test-netconnection -computername $target -port $_ } | convertto-csv | add-content .\outbound-ports.csv -PassThru | convertfrom-csv

$csvData = Import-Csv -Path "C:\ADSH\NetworkEgress\outbound-ports.csv" | Group-Object -Property TcpTestSucceeded
$summary = $csvData | ForEach-Object {
    [PSCustomObject]@{
        TcpTestSucceeded = $_.Name
        Count = $_.Count
        RemotePort = ($_.Group | Select-Object -ExpandProperty RemotePort) -join ", "
    }
}

Write-Output "[*] Report Egress" 
$summary | Format-Table -AutoSize

Write-Output "[!] Done"