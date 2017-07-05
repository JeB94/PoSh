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
        Write-Verbose "Querying $Computer"

        $Command = {
            Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power\' -Name hiberbootenabled
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
            $FastBootState = Invoke-Command @Parameters 

            $Output = @{
                ComputerName = $Computer
            }

            if ($FastBootState.HiberbootEnabled) {
                $Output.State = "Enabled"    
            }
            else {
                $Output.State = "Disabled"
            }

            Write-Verbose "Outputting state of $Computer"
            [PSCustomObject]$Output
            
        }
        catch {
            Write-Error $_
        } # catch 
    } # foreach
} # process