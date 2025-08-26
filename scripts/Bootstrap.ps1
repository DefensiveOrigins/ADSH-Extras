# Ensure log directory
cd c:\ADSH
New-Item -ItemType Directory -Path "C:\ADSH\Bootstrap" -Force > $null
$LogFile = "C:\ADSH\Bootstrap\Bootstrap.log"
New-Item -ItemType Directory -Force -Path (Split-Path $LogFile) | Out-Null
function BootStrapLog { param($m) Add-Content -Path $LogFile -Value "[$(Get-Date -Format s)] $m" }

BootStrapLog "---- Bootstrap start ----"
# Windows Features

BootStrapLog "---- Check FS-FileServer ----"
$feature = Get-WindowsFeature FS-FileServer
if ($feature.InstallState -ne 'Installed') {
    BootStrapLog "Installing FS-FileServer"
    Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools
} else { BootStrapLog "FS-FileServer already installed" }

BootStrapLog "---- Check FS-Resource-Manager ----"
$feature = Get-WindowsFeature FS-Resource-Manager
if ($feature.InstallState -ne 'Installed') {
    BootStrapLog "Installing FS-Resource-Manager"
    Install-WindowsFeature -Name FS-Resource-Manager -IncludeManagementTools
} else { BootStrapLog "FS-Resource-Manager already installed" }

BootStrapLog "---- Check ADCS ----"
$feature = Get-WindowsFeature AD-Certificate 
if ($feature.InstallState -ne 'Installed') {
    BootStrapLog "Installing ADCS"
    Install-WindowsFeature -Name AD-Certificate  -IncludeManagementTools
} else { BootStrapLog "FS-Resource-Manager already installed" }

# NuGet PackageProvider
BootStrapLog "---- Checking NuGet provider ----"
$prov = Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending | Select-Object -First 1
if (-not $prov -or [version]$prov.Version -lt [version]'2.8.5.201') {
    BootStrapLog "Installing/Updating NuGet provider"
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
} else { BootStrapLog "NuGet provider OK" }

BootStrapLog "---- Checking PSWriteColor module ----"
if (-not (Get-Module -ListAvailable -Name PSWriteColor)) {
    BootStrapLog "Installing PSWriteColor"
    Install-Module -Name PSWriteColor -Force -SkipPublisherCheck -Scope AllUsers
} else { BootStrapLog "PSWriteColor already installed" }

# PowerShell Modules
BootStrapLog "---- Checking GPOZaurr module ----"
if (-not (Get-Module -ListAvailable -Name GPOZaurr)) {
    BootStrapLog "Installing GPOZaurr"
    Install-Module -Name GPOZaurr -AllowClobber -Force -Scope AllUsers
} else { BootStrapLog "GPOZaurr already installed" }

BootStrapLog "---- Checking Testimo module ----"
if (-not (Get-Module -ListAvailable -Name Testimo)) {
    BootStrapLog "Installing Testimo"
    Install-Module -Name Testimo -AllowClobber -Force -SkipPublisherCheck -Scope AllUsers
} else { BootStrapLog "Testimo already installed" }

BootStrapLog "---- .Net Runtime ----"

# .NET Runtime 8.0.19
$dotnetVer = "8.0.19"
$dotnetDir = "C:\Program Files\dotnet\shared\Microsoft.NETCore.App\$dotnetVer"
$dotnetUrl = "https://builds.dotnet.microsoft.com/dotnet/Runtime/$dotnetVer/dotnet-runtime-$dotnetVer-win-x64.exe"
$dotnetInstaller = "C:\ProgramData\ADSH-Bootstrap\dotnet-runtime-$dotnetVer-win-x64.exe"

if (-not (Test-Path $dotnetDir)) {
    BootStrapLog "Downloading .NET Runtime $dotnetVer"
    Invoke-WebRequest -Uri $dotnetUrl -OutFile $dotnetInstaller -UseBasicParsing
    BootStrapLog "Installing .NET Runtime $dotnetVer"
    Start-Process -FilePath $dotnetInstaller -ArgumentList '/install','/quiet','/norestart' -Wait
    BootStrapLog ".NET Runtime $dotnetVer install attempted"
} else { BootStrapLog ".NET Runtime $dotnetVer already installed" }


BootStrapLog "---- Bootstrap complete ----"
