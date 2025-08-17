Install-WindowsFeature -Name FS-Resource-Manager, FS-FileServer –IncludeManagementTools


New-Item -ItemType Directory -Path "C:\ADSH\PIIShare" -Force > $null
$ShareRoot = 'C:\ADSH\PIIShare'
$ShareName = 'PIIShare'
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
$DomainNetBIOS = try { (Get-ADDomain).NetBIOSName } catch { $env:USERDOMAIN }
$AdminsGroup   = "$DomainNetBIOS\Domain Admins"
$UsersGroup    = "$DomainNetBIOS\Domain Users"

# Create folder and set NTFS AC 
New-Item -ItemType Directory -Path $ShareRoot -Force | Out-Null
$acl = Get-Acl $ShareRoot
$ruleAdmins = New-Object System.Security.AccessControl.FileSystemAccessRule($AdminsGroup,'FullControl','ContainerInherit, ObjectInherit','None','Allow')
$ruleUsers  = New-Object System.Security.AccessControl.FileSystemAccessRule($UsersGroup,'Modify','ContainerInherit, ObjectInherit','None','Allow')
$acl.SetAccessRule($ruleAdmins)
$acl.SetAccessRule($ruleUsers)
Set-Acl -Path $ShareRoot -AclObject $acl

# Create the SMB share
if (-not (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
    New-SmbShare -Name $ShareName -Path $ShareRoot `
        -FullAccess $AdminsGroup `
        -ChangeAccess $UsersGroup `
        -FolderEnumerationMode AccessBased | Out-Null
}


Import-Module FileServerResourceManager


"Employee: Jane Doe`nSSN: 123-45-6789" | Set-Content -Path (Join-Path $ShareRoot 'HR-Notes.txt') -Encoding UTF8
"AWS_ACCESS_KEY_ID=AKIAEXAMPLE1234567890`nAWS_SECRET_ACCESS_KEY=abCDefGhijkLMNOPqrstUVWXyz0123456789" | Set-Content -Path (Join-Path $ShareRoot 'dev-secrets.txt') -Encoding UTF8

  ls C:\ADSH\PIIShare\ | Select-Object Name, Length


  
Set-ExecutionPolicy bypass
iex ((New-Object System.Net.WebClient).DownloadString("https://github.com/DefensiveOrigins/ADSH-Extras/raw/refs/heads/main/scripts/MoreSens.ps1"))

ls -r C:\ADSH\PIIShare\ | Select-Object Name, Length


New-FsrmClassificationPropertyDefinition -Name 'PII' -DisplayName 'PII Detected' -Type YesNo 

Get-FsrmClassificationPropertyDefinition |  format-table -Property Name, DisplayName, AppliesTo, Type

$ssnRegex = '(?!(\d){3}(-| |)\1{2}\2\1{4})(?!666|000|9\d{2})(\b\d{3}(-| |)(?!00)\d{2}\4(?!0{4})\d{4}\b)'

New-FsrmClassificationRule -Name 'Detect-SSN' `
        -Description 'Mark files containing US SSNs as PII' `
        -Namespace @($ShareRoot) `
        -ClassificationMechanism 'Content Classifier' `
        -Property 'PII' -PropertyValue 1 `
        -ContentRegularExpression $ssnRegex `
        -ReevaluateProperty  Overwrite 


Get-FsrmClassificationRule | format-table -Property Name, Property, PropertyValue, ContentRegularExpression, Namespace

ls C:\StorageReports\Interactive | Select-Object Name, Length


fsrm.msc


New-Item -ItemType Directory -Path "C:\ADSH\Snaffler" -Force > $null
cd C:\ADSH\Snaffler
Invoke-WebRequest -URI "https://github.com/DefensiveOrigins/SharpCollection/raw/refs/heads/master/NetFramework_4.5_Any/Snaffler.exe" -OutFile C:\ADSH\Snaffler\snaffler.exe

.\snaffler.exe  -s -i c:\ADSH\PIIShare -o Snafflerlog-PIIShare.txt


cd C:\ADSH\Snaffler
 .\snaffler.exe  -s -o Snafflerlog-full.txt

