[CmdletBinding()]
param (
    [parameter(Position = 0)]
    [String[]]$ComputerName = "Localhost",
    $Credential 

)

# Disable  = 1
$Command = { Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections -Value '1' }

$Params = @{
            ComputerName = $ComputerName
            ScriptBlock  = $Command
            }

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) 
{ $Params.remove("ComputerName") }

IF ($Credential -ne $null) { $Params.credential = $Credential }
Invoke-Command @Params