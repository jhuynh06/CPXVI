wmic UserAccount get Name | Out-File -FilePath .\Windows10\Users\currentUsers.txt
# Spacing needs to be fixed
Get-Content .\Windows10\Users\currentUsers.txt | Sort-Object | get-unique > .\Windows10\Users\sortedCurrentUsers.txt
Get-Content .\Windows10\Users\competitionUsers.txt | Sort-Object | get-unique > .\Windows10\Users\sortedCompetitionUsers.txt
$file2 = Get-Content -Path .\Windows10\Users\sortedCompetitionUsers.txt
$diff = Get-Content -Path .\Windows10\Users\sortedCurrentUsers.txt | Where-Object {$_ -notin $file2}
$diff | Out-File -FilePath .\Windows10\Users\naughtyUsers.txt

function deleteUsers($users) {
    $answer = Read-Host "Would you like to remove the following users [y/n]"
    #needs to print users
    if ($answer -match '^[Yy]') {
        foreach ($user in $users) {
            Remove-LocalUser -Name $user
        }
        Write-Host "The users were removed."
    }
}