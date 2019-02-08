<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES
    
#>
[CmdletBinding()]

param (

    [pscredential]
    $Credential

)

if (!($Credential)) {
    $Credential = Get-Credential
}

$Parameters = @{ 'ConfigurationName' = "Microsoft.Exchange"
                 'Credential'        = $credential
                 'ConnectionUri'     = "https://outlook.office365.com/powershell-liveid/"
                 'Authentication'    = "Basic"
                 'AllowRedirection'  = $True
}              

$Session = New-PSSession @Parameters

Import-PSSession -Session $session

    