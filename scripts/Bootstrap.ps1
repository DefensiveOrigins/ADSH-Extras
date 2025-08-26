# Ensure log directory
cd c:\ADSH
New-Item -ItemType Directory -Path "C:\ADSH\Bootstrap" -Force > $null
$LogFile = "C:\ADSH\Bootstrap\Bootstrap.log"
New-Item -ItemType Directory -Force -Path (Split-Path $LogFile) | Out-Null
function BootStrapLog { param($m) Add-Content -Path $LogFile -Value "[$(Get-Date -Format s)] $m" }

BootStrapLog "---- Bootstrap start ----"
# Windows Features

BootStrapLog "---- Check CheckContext ----"
New-Item -ItemType Directory -Path "C:\ADSH\Scripts" -Force > $null
if (Test-Path "C:\ADSH\Scripts\CheckContext.ps1") {
    Remove-Item "C:\ADSH\Scripts\CheckContext.ps1" -Force
}
Invoke-WebRequest -URI https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/CheckContext.ps1 -OutFile "C:\ADSH\Scripts\CheckContext.ps1"
BootStrapLog "----  CheckContext Updated ----"

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
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
BootStrapLog "NugGet Installed"

BootStrapLog "---- Checking PSWriteColor module ----"
BootStrapLog "Installing PSWriteColor"
Install-Module -Name PSWriteColor -SkipPublisherCheck -Scope AllUsers
BootStrapLog "PSWriteColor Installed"

# PowerShell Modules
BootStrapLog "---- Checking GPOZaurr module ----"
BootStrapLog "Installing GPOZaurr"
Install-Module -Name GPOZaurr -AllowClobber -Scope AllUsers
BootStrapLog "GPOZaurr Installed"


BootStrapLog "---- Checking Testimo module ----"
BootStrapLog "Installing Testimo"
Install-Module -Name Testimo -AllowClobber -SkipPublisherCheck -Scope AllUsers
BootStrapLog "Testimo Installed"

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


cd c:\ADSH
New-Item -ItemType Directory -Path "C:\ADSH\Scripts" -Force > $null
if (Test-Path "C:\ADSH\Scripts\CheckContext.ps1") {
    Remove-Item "C:\ADSH\Scripts\CheckContext.ps1" -Force
}
Invoke-WebRequest -URI https://raw.githubusercontent.com/DefensiveOrigins/ADSH-Extras/refs/heads/main/scripts/CheckContext.ps1 -OutFile "C:\ADSH\Scripts\CheckContext.ps1"


BootStrapLog "---- Bootstrap complete ----"

