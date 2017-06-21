[CmdletBinding()]
param (
    [Parameter(Mandatory,
        Position = 0,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [Alias("Name")]
    [String[]]
    $VMName, 

    [ValidateNotNullOrEmpty()]
    [String]
    $ComputerName = 'localhost'
)

process {
    foreach ($VM in $VMName) {
        Write-Verbose "Connecting to $VM at $ComputerName"
        vmconnect.exe $ComputerName $VM
        Write-Verbose "Connected to $VM at $ComputerName"
    }
}
