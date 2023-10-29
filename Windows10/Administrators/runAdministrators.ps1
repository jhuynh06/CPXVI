net localgroup Administrators | Out-File -FilePath .\Windows10\Administrators\currentAdministrators.txt
Get-Content .\Windows10\Administrators\currentAdministrators.txt | Sort-Object | get-unique > .\Windows10\Administrators\sortedCurrentAdministrators.txt
Get-Content .\Windows10\Administrators\competitionAdministrators.txt | Sort-Object | get-unique > .\Windows10\Administrators\sortedCompetitionAdministrators.txt
$file2 = Get-Content -Path .\Windows10\Administrators\sortedCompetitionAdministrators.txt
$diff = Get-Content -Path .\Windows10\Administrators\sortedCurrentAdministrators.txt | Where-Object {$_ -notin $file2}
$diff | Out-File -FilePath .\Windows10\Administrators\naughtyAdmins.txt

function removeAdmin($admins) {
    $removeAdmin = Read-Host "Would you like to remove the folwing admins as an admin? [y/n]"
    if ($removeAdmin -match '^[Yy]') {
        Remove-LocalGroupMember -Group "Administrators" -Member $admins
        Write-Host "The admins were removed."
    }
}

$admins = Get-Content -Path '.\Windows10\Administrators\naughtyAdmins.txt'
removeAdmin($admins)


