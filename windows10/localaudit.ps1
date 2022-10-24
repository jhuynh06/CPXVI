$Folder = 'C:\temp'
if (-Not(Test-Path -Path $Folder)) {
    New-Item -Path 'c:\temp' -ItemType Directory
}
secedit /export /cfg c:\temp\secpol.cfg
$secpol = (Get-Content C:\temp\secpol.cfg)

$Value = $secpol | where{ $_ -like "AuditSystemEvents*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditSystemEvents = 3") {
    $secpol.item($Index) = "AuditSystemEvents = 3"
}

$Value = $secpol | where{ $_ -like "AuditLogonEvents*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditLogonEvents = 3") {
    $secpol.item($Index) = "AuditLogonEvents = 3"
}

$Value = $secpol | where{ $_ -like "AuditObjectAccess*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditObjectAccess = 3") {
    $secpol.item($Index) = "AuditObjectAccess = 3"
}

$Value = $secpol | where{ $_ -like "AuditPrivilegeUse*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditPrivilegeUse = 3") {
    $secpol.item($Index) = "AuditPrivilegeUse = 3"
}

$Value = $secpol | where{ $_ -like "AuditPolicyChange*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditPolicyChange = 3") {
    $secpol.item($Index) = "AuditPolicyChange = 3"
}

$Value = $secpol | where{ $_ -like "AuditAccountManage*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditAccountManage = 3") {
    $secpol.item($Index) = "AuditAccountManage = 3"
}

$Value = $secpol | where{ $_ -like "AuditProcessTracking*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditProcessTracking = 3") {
    $secpol.item($Index) = "AuditProcessTracking = 3"
}

$Value = $secpol | where{ $_ -like "AuditDSAccess*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditDSAccess = 3") {
    $secpol.item($Index) = "AuditDSAccess = 3"
}

$Value = $secpol | where{ $_ -like "AuditAccountLogon*" }
$Index = [array]::IndexOf($secpol,$Value)

if($Value -ne "AuditAccountLogon = 3") {
    $secpol.item($Index) = "AuditAccountLogon = 3"
}

$secpol | out-file c:\temp\secpol.cfg -Force


secedit /configure /db c:\windows\security\local.sdb /cfg c:\temp\secpol.cfg /areas SECURITYPOLICY

Remove-Item -Path 'c:\temp' -Recurse