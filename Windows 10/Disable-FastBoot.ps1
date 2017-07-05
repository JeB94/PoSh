#Requires -RunAs
[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [Alias("CN", "Name")]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $ComputerName = $Env:COMPUTERNAME,

    [Pscredential]
    $Credential
)

process {
    Foreach ($Computer in $ComputerName) {
        Write-Verbose "Disabling fastboot on $Computer"

        $Command = {
            Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power\' -Name hiberbootenabled -Value 0
        }

        $Parameters = @{
            Command          = $Command
            ErrorAction      = "Stop"
            ComputerName     = $Computer
            HideComputerName = $True
        }
            
        if ($Computer -in @($Env:COMPUTERNAME, "localhost")) {
            $Parameters.remove('ComputerName')
            $Parameters.remove('HideComputerName')
        } 
        elseIf ($PSBoundParameters.ContainsKey("Credential")) {
            $Parameters.Credential = $Credential
        }  
        
        try {
            Write-Verbose "Connecting to $Computer"
            Invoke-Command @Parameters 

            Write-Output "Fastboot was disabled on $Computer"
            Write-Verbose "Fastboot was disabled on $Computer"
        }
        catch {
            Write-Error $_
        } # catch 
    } # foreach
} # process

