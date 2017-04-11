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

    [PScredential]
    $Credential 

)


$Command = { Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections -Value '0' }

$Params = @{
            ComputerName = $ComputerName
            ScriptBlock  = $Command
            }

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) 
{ $Params.remove("ComputerName") }

IF ($Credential) { $Params.credential = $Credential }

Invoke-Command @Params