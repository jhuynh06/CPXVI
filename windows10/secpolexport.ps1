$Folder = 'C:\temp'
if (-Not(Test-Path -Path $Folder)) {
    New-Item -Path 'c:\temp' -ItemType Directory
}
secedit /export /cfg c:\temp\secpol.cfg
$secpol = (Get-Content C:\temp\secpol.cfg)