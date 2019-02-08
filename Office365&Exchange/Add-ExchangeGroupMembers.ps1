<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES
    
#>
[CmdletBinding()]

param (
    [Parameter(ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [String[]]
    $Group = "Zarcam SA"
)

begin {
    try {
        Write-Verbose "Getting licensed users"
        $LicensedUsers = (Get-MsolUser).Where( { $_.isLicensed -eq $True }) | Select-Object -ExpandProperty UserPrincipalName
        Write-Verbose "Found $($LicensedUsers.Count) licensed users"
    } catch {
        Write-Error "User hasn't logged in to Office365"
        Break
    }

}
process {
    Foreach ($Grupo in $Group) {
        try {
            "Getting member of $Grupo"
            $Consulta = Get-DistributionGroupMember -Identity $Grupo | Select-Object -ExpandProperty primarysmtpaddress

            Foreach ($User in $LicensedUsers) {
                IF (!($Consulta -match $User ) ) {
                    Write-Verbose "Adding $User to $Grupo"
                    Add-distributionGroupMember -Identity $Grupo -Member $User
                    $Output = @{
                        User = $User
                        Grupo = $Grupo
                        Added = $True
                    }
                    
                    [PSCustomObject]$Output
                } # if
            } # foreach
        } catch {
            Write-Error "User hasn't logged in to ExchangeOnline"
        } # try catch
    } # foreach
} # process


    