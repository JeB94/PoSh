[CmdletBinding()]
param (
    [Parameter(Mandatory,
        Position = 0,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [Alias("Name", "vm")]
    [String[]]
    $VMName, 

    [ValidateNotNullOrEmpty()]
    [Alias("Server", "cn")]
    [String]
    $ComputerName = $ENV:COMPUTERNAME
)

process {
    foreach ($VM in $VMName) {
        Write-Verbose "Connecting to $VM at $ComputerName"
        vmconnect.exe $ComputerName $VM
        Write-Verbose "Connected to $VM at $ComputerName"
    } 
} 
