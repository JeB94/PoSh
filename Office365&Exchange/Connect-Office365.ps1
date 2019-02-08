<#

    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER Credential

#>

[CmdletBinding()]
    
Param (

    [PSCredential]
    $Credential
)

if (!($Credential)) {
    $Credential = Get-Credential
}

Connect-MSOLService -Credential $Credential


