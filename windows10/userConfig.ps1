Install-Module -Name ActiveDirectory -Force -Confirm:$false
Get-ADUser -Filter -Properties | export-csv c:\ADusers.csv


#needs active directy on