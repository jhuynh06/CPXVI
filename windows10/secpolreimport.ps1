secpol | out-file c:\temp\secpol.cfg -Force
secedit /configure /db c:\windows\security\local.sdb /cfg c:\temp\secpol.cfg /areas SECURITYPOLICY