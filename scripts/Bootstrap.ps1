# Ensure log directory
cd c:\ADSH
New-Item -ItemType Directory -Path "C:\ADSH\Bootstrap" -Force > $null
$LogFile = C:\ADSH\Bootstrap\Bootstrap.log"
New-Item -ItemType Directory -Force -Path (Split-Path $LogFile) | Out-Null
function Log { param($m) Add-Content -Path $LogFile -Value "[$(Get-Date -Format s)] $m" }

Log "---- Bootstrap start ----"
# Windows Features
$feature = Get-WindowsFeature FS-FileServer
if ($feature.InstallState -ne 'Installed') {
    Log "Installing FS-FileServer"
    Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools
} else { Log "FS-FileServer already installed" }

$feature = Get-WindowsFeature FS-Resource-Manager
if ($feature.InstallState -ne 'Installed') {
    Log "Installing FS-Resource-Manager"
    Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools
} else { Log "FS-Resource-Manager already installed" }

$feature = Get-WindowsFeature AD-Certificate 
if ($feature.InstallState -ne 'Installed') {
    Log "Installing ADCS"
    Install-WindowsFeature -Name AD-Certificate  -IncludeManagementTools
} else { Log "FS-Resource-Manager already installed" }

# NuGet PackageProvider
$prov = Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending | Select-Object -First 1
if (-not $prov -or [version]$prov.Version -lt [version]'2.8.5.201') {
    Log "Installing/Updating NuGet provider"
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
} else { Log "NuGet provider OK" }

if (-not (Get-Module -ListAvailable -Name PSWriteColor)) {
    Log "Installing PSWriteColor"
    Install-Module -Name PSWriteColor -Force -SkipPublisherCheck -Scope AllUsers
} else { Log "PSWriteColor already installed" }

# PowerShell Modules
if (-not (Get-Module -ListAvailable -Name GPOZaurr)) {
    Log "Installing GPOZaurr"
    Install-Module -Name GPOZaurr -AllowClobber -Force -Scope AllUsers
} else { Log "GPOZaurr already installed" }

if (-not (Get-Module -ListAvailable -Name Testimo)) {
    Log "Installing Testimo"
    Install-Module -Name Testimo -AllowClobber -Force -SkipPublisherCheck -Scope AllUsers
} else { Log "Testimo already installed" }

# .NET Runtime 8.0.19
$dotnetVer = "8.0.19"
$dotnetDir = "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\$dotnetVer"
$dotnetUrl = "https://builds.dotnet.microsoft.com/dotnet/Runtime/$dotnetVer/dotnet-runtime-$dotnetVer-win-x64.exe"
$dotnetInstaller = "C:\ProgramData\ADSH-Bootstrap\dotnet-runtime-$dotnetVer-win-x64.exe"

if (-not (Test-Path $dotnetDir)) {
    Log "Downloading .NET Runtime $dotnetVer"
    Invoke-WebRequest -Uri $dotnetUrl -OutFile $dotnetInstaller -UseBasicParsing
    Log "Installing .NET Runtime $dotnetVer"
    Start-Process -FilePath $dotnetInstaller -ArgumentList '/install','/quiet','/norestart' -Wait
    Log ".NET Runtime $dotnetVer install attempted"
} else { Log ".NET Runtime $dotnetVer already installed" }


Log "---- Bootstrap complete ----"
