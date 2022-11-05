# Update PowerShell
# iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

# Installing Modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.85.201 -Force -Confirm:$false
Install-Module -Name AuditPolicyDsc -Force -Confirm:$false
Install-Module -Name SecurityPolicyDsc -Force -Confirm:$false
Install-Module -Name NetworkingDsc -Force -Confirm:$false
Install-Module -Name PSDesiredStateConfiguration -Force -Confirm:$false
Install-Module -Name ActiveDirectory -Force -Confirm:$false

# Setting Policies and Permissions
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force -Confirm:$false
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted -Force -Confirm:$false

#Executing Files
Write-Host "Executing localaudit.ps1"
& "$PSScriptRoot\localaudit.ps1"

Write-Host "Executing services.ps1"
& "$PSScriptRoot\services.ps1"

Write-Host "Executing windows10.ps1"
& "$PSScriptRoot\windows10.ps1"
& "Start-DscConfiguration -Path .\Windows10Hardening  -Force -Verbose -Wait"

#Executes LGPO.exe
$pathlgpo = "${PSScriptRoot}\LGPO.exe"
$pathaudit = "${PSScriptRoot}\audit.csv"
Start-Process -FilePath "cmd.exe"  -ArgumentList "/c $pathlgpo /ac $pathaudit"

Write-Host "Done Executing All Files!"