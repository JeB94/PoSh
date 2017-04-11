<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER alguno

    .EXAMPLE

    .NOTES

#>
[CmdletBinding()]
param (

    [parameter(Position = 0)]
    [String[]]$ComputerName = "Localhost",

    [pscredential]$Credential 

)


$Command = { 
        $Value = (Get-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections).fdenytsconnections

        $dicValues = @{
            0 = "Activado"
            1 = "Desactivado"}

            Write-Output "Remote Desktop se encuentra $($dicValues[$Value])"

}

$Params = @{
            ComputerName = $ComputerName
            ScriptBlock  = $Command
            }

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) 
{ $Params.remove("ComputerName") }

IF ($Credential) { $Params.credential = $Credential }

Invoke-Command @Params

#verificar para aceptar array de computername o no aceptarlo.