# user variables
$userEmail = "arnold.rimmer@contoso.onmicrosoft.com"

# running code
Connect-AzureAD -AccountId $userEmail | Out-Null
Get-AzureADUser -All $true -Filter "accountEnabled eq false and UserType eq 'Member'" | Where-Object {$_.ObjectType -eq "User"} | Select-Object UserPrincipalName | Export-Csv -Path ./newDisabledUsers.csv
$newCSVInformation = Import-Csv -Path .\newDisabledUsers.csv
$newusers = $newCSVInformation.UserPrincipalName
$doItAgain = $False
if (Test-Path -Path ./disabledUsers.csv)
{
    $collectedCSVInformation = Import-Csv -Path .\disabledUsers.csv
    $oldusers = $collectedCSVInformation.UserPrincipalName

    $users = @();

    foreach ($i in $newusers)
    {
        if ($i -inotin $oldusers)
        {
            $users += $i
        }
    }

    if ($users.Length -gt 0)
    {
        Get-AzureADUser -All $true | Where-Object {$_.UserPrincipalName -in $users} | Select-Object ObjectType, AccountEnabled, DisplayName, MailNickName, Mail, UserPrincipleName, Department, UserType, LastDirSyncTime, @{Name="Link"; Expression={"https://forms.office.com/Pages/delegatepage.aspx?originalowner=$($_.Mail)"}} | Export-Csv -Path ./newinformation.csv
        
        Write-Output "USERS TO ACTION:"
        Write-Output "================"
        Write-Output $users
        Write-Output "================"
        .\newinformation.csv
    }
}
else
{
    Write-Output "no original file found, creating from collected information..."
    Write-Output "NOTE: script needs to be run again for report!"
    $doItAgain = $True
}
 Move-Item -Path .\newDisabledUsers.csv -Destination .\disabledUsers.csv -Force
 Write-Output "Script run complete"

 if ($doItAgain)
 {
    $scriptLocation = "$PSScriptRoot\$($MyInvocation.MyCommand.Name)"
    Write-Host "Re-Running $scriptLocation"
    . "$scriptLocation"
 }
    