# Parse key fields from a 4625 (Failed logon) event
function Parse-4625 {
    param([System.Diagnostics.Eventing.Reader.EventRecord]$Event)
    $xml = [xml]$Event.ToXml()
    $data = @{}
    foreach ($d in $xml.Event.EventData.Data) { $data[$d.Name] = $d.'#text' }

    [pscustomobject]@{
        TimeCreated   = $Event.TimeCreated
        TargetUser    = $data['TargetUserName']
        TargetDomain  = $data['TargetDomainName']
        LogonType     = $data['LogonType']
        IpAddress     = $data['IpAddress']
        Workstation   = $data['WorkstationName']
        FailureReason = $data['FailureReason']
        Status        = $data['Status']
        SubStatus     = $data['SubStatus']
        ProcessName   = $data['ProcessName']
        LogonProcess  = $data['LogonProcessName']
        AuthPackage   = $data['AuthenticationPackageName']
    }
}

# Parse key fields from a 4624 (Successful logon) event
function Parse-4624 {
    param([System.Diagnostics.Eventing.Reader.EventRecord]$Event)
    $xml = [xml]$Event.ToXml()
    $data = @{}
    foreach ($d in $xml.Event.EventData.Data) { $data[$d.Name] = $d.'#text' }

    [pscustomobject]@{
        TimeCreated   = $Event.TimeCreated
        TargetUser    = $data['TargetUserName']
        TargetDomain  = $data['TargetDomainName']
        LogonType     = $data['LogonType']
        IpAddress     = $data['IpAddress']
        Workstation   = $data['WorkstationName']
        LogonProcess  = $data['LogonProcessName']
        AuthPackage   = $data['AuthenticationPackageName']
        ProcessName   = $data['ProcessName']
    }
}
