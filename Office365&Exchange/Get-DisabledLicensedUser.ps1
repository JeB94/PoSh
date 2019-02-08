<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES
    
#>
[CmdletBinding()]

param ( )

process {

    try {
        $DisabledUsers = Get-MsolUser  -EnabledFilter DisabledOnly -ErrorAction Stop
        Write-Verbose "Getting disabled users from Office365" 
        foreach ($User in $DisabledUsers) {
            Write-Verbose "Disabled user found: $($User.DisplayName) - $($User.UserPrincipalName)"
            if ($User.isLicensed) {
                Write-Verbose "User $($User.DisplayName) has a license assigned"
                $Output = [Ordered]@{
                    DisabledOnly = $User
                    isLicensed   = $True
                }

                Write-Verbose "Outputting details: $($User.DisplayName)"                
                [PSCustomObject]$Output

            } else {
                Write-Verbose "User has not a license assigned: $($User.DisplayName)"
            }
        }

        Write-Output $ArrayObjects
 
    } Catch {
        Write-Error "User hasn't logged in to Office365"
    }
} # process
