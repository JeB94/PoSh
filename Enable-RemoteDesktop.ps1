[CmdletBinding()]
param (
    [parameter(Position = 0)]
    [String[]]$ComputerName = "Localhost",
    $Credential 

)

# Enable  = 0
$Command = { Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name fdenytsconnections -Value '0' }

$Params = @{
            ComputerName = $ComputerName
            ScriptBlock  = $Command
            }

IF ($ComputerName -eq "Localhost" -or $ComputerName -eq $env:COMPUTERNAME) 
{ $Params.remove("ComputerName") }

IF ($Credential -ne $null) { $Params.credential = $Credential }
Invoke-Command @Params