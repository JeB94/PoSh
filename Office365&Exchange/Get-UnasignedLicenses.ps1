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
        Write-Verbose "Getting licences details from Office365"
        $AccountSkuID = (Get-MsolAccountSku -ErrorAction Stop).Where( {$_.AccountSkuId -notmatch "Power_Bi_Standard"})

        Foreach ($SkuId in $AccountSkuID) {
            $SkuId.AccountSkuId -match "[a-z]+:([a-z]+)" | Out-Null
            $LicenseName = $Matches[1]
            Write-Verbose "Analyzing $LicenseName"
            if ($SkuId.ActiveUnits -gt $SkuId.ConsumedUnits) {
                $Output = @{
                    AccountSkuID = $SkuId.AccountSkuID
                }

                #Gets group of matched regex
                $Output.LicenseName = $LicenseName

                $Output.UnassignedLicenses = $SkuId.ActiveUnits - $SkuId.ConsumedUnits

                Write-Verbose "Outputting $($Output.LicenseName)"
                [PSCustomObject]$Output
            } else {
                Write-Warning "The are not unasigned license for $LicenseName"
            } 
        } # foreach sku
    } catch {
        Write-Error "User hasn't logged in to Office365"
    } # try catch
} # process
