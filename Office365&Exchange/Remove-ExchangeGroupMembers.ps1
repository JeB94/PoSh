<#
    .SYNOPSIS
  
    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES
    
#>
[CmdletBinding()]

param (
    [String]
    $Group = "Zarcam SA"
)

process {
    $ArrayObjects = New-Object System.Collections.Generic.List[System.Object]
 
    try {
        $Members = (Get-DistributionGroupMember -Identity $Group).Where( { $_.RecipientType -eq "User" })
        Foreach ($Member in $Members) {
            $PropertyObject = @{}
            Remove-DistributionGroupMember -Identity $Group -Member $Member.Name -Confirm:$False
            $PropertyObject.RemovedUsers = $Member.Name
            $Object = New-Object PSObject -Property $PropertyObject 
            $ArrayObjects.Add($Object)
        } 
        Write-Output $ArrayObjects
    } catch {
        Write-Error -Message "Usuario no conectado a Exchange Online. Usar Script 'Connect-ExchangeOnline.ps1'. Ejecutar desde una consola. " 
    }
}