Install-Module -Name AuditPolicyDsc -Force -Confirm:$false
Install-Module -Name SecurityPolicyDsc -Force -Confirm:$false
Install-Module -Name NetworkingDsc -Force -Confirm:$false
Install-Module -Name PSDesiredStateConfiguration -Force -Confirm:$false

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force -Confirm:$false
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted -Force -Confirm:$false

Write-Host "Executing windows10.ps1"
& "$PSScriptRoot\windows10.ps1"
& "Start-DscConfiguration -Path .\Windows10Hardening  -Force -Verbose -Wait"

<#
Write-Host "Executing localaudit.ps1"
& "$PSScriptRoot\localaudit.ps1"
#>